#!/usr/bin/env bash
# DNS leak check for dnscrypt-proxy. See README.md in this directory.
#
#   sudo BIN=/path/to/dnscrypt-proxy ./leak-test.sh
#
# It starts the daemon with the packaged configuration and two pinned servers,
# captures the traffic that leaves the machine, sends queries with random names to
# the daemon, and looks for those names in the capture. It also sends one plain DNS
# query on purpose. That query must be found, otherwise the search proves nothing.
#
# Exit status: 0 no query name was seen in clear text and the control was found,
#              1 a query name was seen in clear text,
#              2 the test could not be run or the control was not found.
#
# The capture holds real network traffic. It is deleted at the end unless
# KEEP_CAPTURE=1 is set. Never commit it.
set -u
HERE=$(cd "$(dirname "$0")" && pwd)
BIN=${BIN:?set BIN to the dnscrypt-proxy binary}
SERVERS=${SERVERS:-scaleway-fr,a-and-a}
PORT=${PORT:-6500}
WORK=${WORK:-$(mktemp -d)}
IFACE=${IFACE:-$(ip route get 9.9.9.9 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "dev") { print $(i + 1); exit }}')}

for tool in tcpdump python3 ip; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool"; exit 2; }
done
[ "$(id -u)" = 0 ] || { echo "run as root: tcpdump needs it"; exit 2; }
[ -x "$BIN" ] || { echo "BIN is not executable: $BIN"; exit 2; }
[ -n "$IFACE" ] || { echo "could not find the network interface, set IFACE"; exit 2; }

mkdir -p "$WORK/cache"
names=$(printf "'%s', " ${SERVERS//,/ })
sed -e "s#127.0.0.1:5359#127.0.0.1:$PORT#" \
    -e 's#use_syslog = true#use_syslog = false#' \
    -e "s#/tmp/dnscrypt-proxy/#$WORK/cache/#g" \
    -e "s#^max_clients = 250#max_clients = 250\nserver_names = [${names%, }]#" \
    "$HERE/../files/dnscrypt-proxy.toml" > "$WORK/leak.toml"

cleanup() {
  [ -n "${DP:-}" ] && kill "$DP" 2>/dev/null
  [ -n "${TD:-}" ] && kill "$TD" 2>/dev/null
  wait 2>/dev/null
  if [ "${KEEP_CAPTURE:-0}" = 1 ]; then echo "capture kept: $WORK/leak.pcap (it contains real traffic)"; else rm -f "$WORK/leak.pcap"; fi
}
trap cleanup EXIT

tcpdump -i "$IFACE" -n -s 0 -w "$WORK/leak.pcap" >/dev/null 2>&1 &
TD=$!
sleep 2
"$BIN" -config "$WORK/leak.toml" > "$WORK/daemon.log" 2>&1 &
DP=$!

python3 - "$PORT" "$WORK" <<'EOF'
import json, os, random, socket, struct, sys, time
port, work = int(sys.argv[1]), sys.argv[2]
random.seed()

def query(name, port, host='127.0.0.1', timeout=10):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(timeout)
    m = struct.pack('>HHHHHH', random.randint(0, 65535), 0x0100, 1, 0, 0, 0)
    for p in name.split('.'):
        m += bytes([len(p)]) + p.encode()
    s.sendto(m + b'\x00' + struct.pack('>HH', 1, 1), (host, port))
    try:
        r, _ = s.recvfrom(4096)
        return struct.unpack('>H', r[2:4])[0] & 0xf
    except OSError:
        return None

ready = False
for _ in range(60):
    if query('example.com', port) == 0:
        ready = True
        break
    time.sleep(2)
tokens = ['leaktest%08x' % random.getrandbits(32) for _ in range(15)]
rcodes = [query(t + '.example.com', port) for t in tokens]
control = 'control%08x' % random.getrandbits(32)
query(control + '.example.com', 53, host='9.9.9.9', timeout=3)       # plain DNS, on purpose
json.dump({'ready': ready, 'tokens': tokens, 'control': control, 'rcodes': rcodes}, open(os.path.join(work, 'leak.json'), 'w'))
print('daemon ready: %s, answers to the %d test queries: %s' % (ready, len(tokens), 'all' if all(r is not None for r in rcodes) else rcodes))
EOF
sleep 3
kill "$DP" 2>/dev/null; wait "$DP" 2>/dev/null; DP=
kill "$TD" 2>/dev/null; wait "$TD" 2>/dev/null; TD=

python3 - "$WORK" <<'EOF'
import collections, json, os, re, subprocess, sys
work = sys.argv[1]
j = json.load(open(os.path.join(work, 'leak.json')))
raw = open(os.path.join(work, 'leak.pcap'), 'rb').read()
found = [t for t in j['tokens'] if t.encode() in raw]
control = j['control'].encode() in raw
print('capture: %d bytes' % len(raw))
print('query names seen in clear text: %d of %d' % (len(found), len(j['tokens'])))
print('control (plain query sent on purpose) seen: %s' % control)
out = subprocess.run(['tcpdump', '-nn', '-r', os.path.join(work, 'leak.pcap'), 'udp port 53 or tcp port 53'], capture_output=True, text=True).stdout.splitlines()
asked = [l for l in out if re.search(r' (A|AAAA|HTTPS|SVCB|TXT)\? ', l)]
dest = collections.Counter(m.group(1) for m in (re.search(r'> ([0-9.]+)\.53:', l) for l in asked) if m)
names = collections.Counter(re.search(r'(?:A|AAAA|HTTPS|SVCB|TXT)\? (\S+)', l).group(1).rstrip('.') for l in asked)
print('plain DNS queries on port 53: %d, sent to %s' % (len(asked), dict(dest)))
for n, c in sorted(names.items()):
    print('   asked in clear text: %s (%d)' % (n, c))
if not j['ready']:
    print('RESULT INCONCLUSIVE: the daemon was not ready'); sys.exit(2)
if found:
    print('RESULT FAIL: query names were visible in the capture'); sys.exit(1)
if not control:
    print('RESULT INCONCLUSIVE: the control was not found, so the search proves nothing'); sys.exit(2)
print('RESULT PASS')
EOF
