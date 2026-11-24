# Tests

Checks that can be repeated for this package. None of them is part of the firmware
build, and none needs a Keenetic device. Two directories hold tests:

- `tests/` (this directory): checks of the daemon, as a binary on a Linux machine.
- `gui/tests/`: checks of the settings page templates (see `gui/README.md`).

The scripts in this directory test a binary of `dnscrypt-proxy`. Build one for the
machine you run them on from the same source that the package builds, with the
patch applied:

    tar xzf dnscrypt-proxy-2.1.21.tar.gz && cd dnscrypt-proxy-2.1.21
    patch -p1 < <sdk>/package/net/dnscrypt-proxy/patches/001-add-socket-mark.patch
    CGO_ENABLED=0 GOFLAGS=-mod=vendor go build -trimpath -buildvcs=false -o dnscrypt-proxy ./dnscrypt-proxy

## What they need

| | `leak-test.sh` | `robustness-test.sh`, `load-test.py`, `abuse-test.py` |
|---|---|---|
| System | Linux, root | Linux. Step E also needs root or user namespaces (`unshare -n`). |
| Tools | `tcpdump`, `python3`, `ip` | `python3` |
| Network | Internet access to the public resolvers | Internet access to the public resolvers |

All of them talk to real public resolvers and to the resolver lists. Their results
depend on those servers, on the network between you and them, and on the three
pinned server names (`scaleway-fr`, `a-and-a`, `cloudflare`), which must still be in
the public list. Set `SERVERS` to other names from `dnscrypt-proxy -list` if they are not.
The scripts use ports from 6500 on.

## The scripts

| Script | What it checks | How to run |
|---|---|---|
| `leak-test.sh` | The names of 15 random queries do not appear in clear text on the network interface. It also lists the plain DNS that the daemon sends. A plain query that is sent on purpose has to be found, otherwise the search proves nothing. | `sudo BIN=./dnscrypt-proxy ./leak-test.sh` |
| `robustness-test.sh` | Load with SIGHUP, hostile input, SIGTERM, kill -9 and restart, and no network. It starts the daemon itself. | `BIN=./dnscrypt-proxy DURATION=120 ./robustness-test.sh` |
| `load-test.py` | About 40 queries per second from six clients. Every query has to be answered. Prints latency, memory, threads, open files and CPU. | Used by `robustness-test.sh`. |
| `abuse-test.py` | 6000 malformed UDP packets, a compression loop, a name longer than 255 bytes and 400 idle or half-open TCP connections. The daemon has to survive and keep answering. | Used by `robustness-test.sh`. |

Each script ends with `RESULT PASS`, `RESULT FAIL` or `RESULT INCONCLUSIVE`, and an
exit status that says the same.

## Notes

- `leak-test.sh` captures real traffic. It deletes the capture when it ends. Set
  `KEEP_CAPTURE=1` to keep it, and never commit it.
- The leak test pins one DNSCrypt and one DoH server. It does not use relays or ODoH.
  It looks at one interface and does not look at traffic on the loopback interface.
- The load test is minutes long and run on one machine. It says nothing about
  hours-long behaviour or about a router CPU.
- `socket_mark` needs `CAP_NET_ADMIN`. The unit tests of the patch skip when they
  run without it, and they cannot run under `qemu-user`, which refuses `SO_MARK`.
  The upstream test `TestNewSource` cannot pass as root, because its cases that make
  a cache file unreadable do not fail for root. Run the Go tests as an unprivileged
  user, for example with `setpriv --reuid=65534 --regid=65534 --clear-groups`.
