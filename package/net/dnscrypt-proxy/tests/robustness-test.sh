#!/usr/bin/env bash
# Robustness checks for dnscrypt-proxy. See README.md in this directory.
#
#   BIN=/path/to/dnscrypt-proxy [DURATION=120] ./robustness-test.sh
#
# It starts the daemon itself with the packaged configuration and three pinned
# servers, then runs:
#   A  a load test (load-test.py) with SIGHUP in the middle,
#   B  hostile input (abuse-test.py),
#   C  SIGTERM: the daemon has to stop with exit status 0,
#   D  kill -9 and a new start, three times: it has to answer within 30 seconds,
#   E  no network at all (an empty network namespace): it has to stay up and may not
#      use more than 5 percent of a core. Whether it answers is only reported.
# Step E needs root, or user namespaces, and is skipped otherwise.
#
# Exit status: 0 all checks passed, 1 a check failed.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
BIN=${BIN:?set BIN to the dnscrypt-proxy binary}
SERVERS=${SERVERS:-scaleway-fr,a-and-a,cloudflare}
DURATION=${DURATION:-120}
PORT=${PORT:-6600}
WORK=${WORK:-$(mktemp -d)}
failures=0
[ -x "$BIN" ] || { echo "BIN is not executable: $BIN"; exit 1; }
command -v python3 >/dev/null || { echo "python3 is needed"; exit 1; }

fail() { echo "  FAIL: $*"; failures=$((failures + 1)); }

mkcfg() {   # name port
  mkdir -p "$WORK/cache-$1"
  rm -f "$WORK/cache-$1"/*
  local names
  names=$(printf "'%s', " ${SERVERS//,/ })
  sed -e "s#127.0.0.1:5359#127.0.0.1:$2#" \
      -e 's#use_syslog = true#use_syslog = false#' \
      -e "s#/tmp/dnscrypt-proxy/#$WORK/cache-$1/#g" \
      -e "s#^max_clients = 250#max_clients = 250\nserver_names = [${names%, }]#" \
      "$HERE/../files/dnscrypt-proxy.toml" > "$WORK/$1.toml"
}

ready() {   # port seconds: prints the time until the first answer, or "never"
  python3 - "$1" "$2" <<'EOF'
import random, socket, struct, sys, time
port, limit = int(sys.argv[1]), float(sys.argv[2])
t0 = time.time()
while time.time() - t0 < limit:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(3)
    m = struct.pack('>HHHHHH', random.randint(0, 65535), 0x0100, 1, 0, 0, 0) + b'\x07example\x03com\x00' + struct.pack('>HH', 1, 1)
    try:
        s.sendto(m, ('127.0.0.1', port))
        r, _ = s.recvfrom(4096)
        if struct.unpack('>H', r[2:4])[0] & 0xf == 0:
            print('%.1f' % (time.time() - t0))
            sys.exit(0)
    except OSError:
        pass
    time.sleep(0.5)
print('never')
sys.exit(1)
EOF
}

echo "A. load test for $DURATION s, SIGHUP in the middle (servers: $SERVERS)"
mkcfg load "$PORT"
"$BIN" -config "$WORK/load.toml" > "$WORK/load.log" 2>&1 &
P=$!
t=$(ready "$PORT" 90) || fail "the daemon did not answer within 90 s"
echo "  first answer after $t s"
python3 "$HERE/load-test.py" --port "$PORT" --pid "$P" --duration "$DURATION" --hup-at $((DURATION / 2)) || fail "load test"
kill -0 "$P" 2>/dev/null || fail "the daemon is gone after the load test"
grep -q 'Received SIGHUP' "$WORK/load.log" && echo "  the log shows that SIGHUP was handled" || fail "no log line about SIGHUP"
echo "  warnings and errors in the daemon log: $(grep -c -E '\[(ERROR|WARN|CRITICAL|FATAL)\]' "$WORK/load.log")"

echo "B. hostile input"
python3 "$HERE/abuse-test.py" --port "$PORT" --pid "$P" || fail "hostile input"

echo "C. SIGTERM"
kill -TERM "$P"; wait "$P"; rc=$?
echo "  exit status $rc, last log line: $(tail -1 "$WORK/load.log" | sed -E 's/^\[[^]]*\] //')"
[ "$rc" = 0 ] || fail "SIGTERM did not end with exit status 0"

echo "D. kill -9 and start again"
mkcfg kill "$((PORT + 1))"
for i in 1 2 3; do
  "$BIN" -config "$WORK/kill.toml" > "$WORK/kill.log" 2>&1 &
  K=$!
  t=$(ready "$((PORT + 1))" 30) || { fail "run $i: no answer within 30 s"; t=never; }
  kill -9 "$K" 2>/dev/null; wait "$K" 2>/dev/null
  echo "  run $i: first answer after $t s"
done

echo "E. no network"
if unshare -n true 2>/dev/null; then
  mkcfg nonet "$((PORT + 2))"
  cat > "$WORK/nonet-inner.sh" <<EOF
#!/usr/bin/env bash
ip link set lo up
"$BIN" -config "$WORK/nonet.toml" > "$WORK/nonet.log" 2>&1 &
D=\$!
sleep 20
alive=\$(kill -0 \$D 2>/dev/null && echo yes || echo no)
python3 - "$((PORT + 2))" <<'PY'
import random, socket, struct, sys, time
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.settimeout(12)
m = struct.pack('>HHHHHH', 5, 0x0100, 1, 0, 0, 0) + b'\x07example\x03com\x00' + struct.pack('>HH', 1, 1)
t = time.time()
s.sendto(m, ('127.0.0.1', int(sys.argv[1])))
try:
    r, _ = s.recvfrom(4096)
    print('  a query got rcode %d after %.1f s' % (struct.unpack('>H', r[2:4])[0] & 0xf, time.time() - t))
except OSError:
    print('  a query got no answer within 12 s')
PY
t1=\$(awk '{print \$14 + \$15}' /proc/\$D/stat); sleep 30; t2=\$(awk '{print \$14 + \$15}' /proc/\$D/stat)
hz=\$(getconf CLK_TCK)
echo "  alive after 20 s: \$alive, CPU in 30 s: \$((t2 - t1)) ticks (\$(( (t2 - t1) * 100 / 30 / hz ))% of a core)"
[ "\$alive" = yes ] && kill -0 \$D 2>/dev/null && [ \$(( (t2 - t1) * 100 / 30 / hz )) -le 5 ]
rc=\$?
kill \$D 2>/dev/null; wait \$D 2>/dev/null
exit \$rc
EOF
  unshare -n bash "$WORK/nonet-inner.sh" || fail "the daemon did not stay up quietly without a network"
else
  echo "  skipped: unshare -n is not available here"
fi

echo
if [ "$failures" = 0 ]; then echo "RESULT PASS"; exit 0; fi
echo "RESULT FAIL ($failures)"; exit 1
