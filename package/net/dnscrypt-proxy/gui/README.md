# Settings page templates for DNSCrypt

A working prototype of a settings page for this package, built as a design
reference. It is **not installed** on a device (the package `Makefile` does not
copy this directory), it is not part of KeeneticOS, and it does not control a
running daemon. It shows which choices a user would get and produces a
`dnscrypt-proxy.toml` from them.

## What it looks like and what it does not

The structure follows the public support article "DoH and DoT proxy servers for DNS
requests encryption": a table of servers on the DNS configuration tab, an
"Add server" link that opens the fields, "Any interface" as the default connection
interface, a limit of 8 servers, and a note that servers are used by response time.
The wording and the fields of the real KeeneticOS page were not available, so the
colours, fonts and exact layout are neutral and do not copy the real interface.
The templates are meant to be restyled by whoever owns that interface.

## Open it

The files are static. No build step and no network access are needed.

    cd package/net/dnscrypt-proxy/gui
    python3 -m http.server 8000      # then open http://127.0.0.1:8000/

A browser opens `index.html` from a file as well, but then it cannot load the
sample list by itself. Use the "Resolver list file" button instead.

Create the real list of servers and relays with the daemon:

    dnscrypt-proxy -config <file> -list-all -include-relays -json > resolvers.json

Without that file the page shows nine made-up sample entries
(`sample-resolvers.json`).

## What a user can do

| Choice | Where it ends up in `dnscrypt-proxy.toml` |
|---|---|
| Pick DNSCrypt, DoH or Oblivious DoH servers from the list, with filters for protocol, port 443, DNSSEC, no logs, no filtering and IPv6 | `server_names`, `dnscrypt_servers`, `doh_servers`, `odoh_servers`, `[sources.*]` |
| Enter a DNS stamp of their own, for example a private DNSCrypt server | `[static.<name>]` and `server_names` |
| Change the port inside a DNSCrypt or relay stamp | the stamp, rewritten |
| Enter a DoH address, for example a personal profile such as `https://dns.example/<profile-id>`, with an optional server IP | `[static.<name>]` with a generated stamp |
| Choose relays from the list, paste relay stamps, or let the proxy choose | `[anonymized_dns]` `routes` and `skip_incompatible` |
| Use TCP for DNSCrypt | `force_tcp` |
| Use HTTP/3 for DoH | `http3` |
| Post-quantum key exchange | `pqdnscrypt` |
| Required server properties | `require_dnssec`, `require_nolog`, `require_nofilter` |
| Listen address, bootstrap resolvers | `listen_addresses`, `bootstrap_resolvers` |
| Socket mark | `socket_mark` (needs the patch of this package) |
| Connection interface | shown as "Any interface" and disabled. It needs the system side to map an interface to a socket mark. |

The page also shows warnings that follow from how the daemon behaves:

- A server picked by name is used even if it does not advertise the required
  properties.
- Oblivious DoH works only through a relay.
- A plain DoH server has no relay.
- Anonymized DNSCrypt over UDP may fail when large packets are dropped.
- A listen address that is not a loopback address exposes the proxy to the network.

## About ports and censorship

The port is part of a server's stamp and the server operator chooses it. The page
can rewrite it, but a server answers only on ports it listens on. Most DNSCrypt
servers and relays in the public lists listen on 443. Using port 443 may get past
rules that block by port. It does not hide that the traffic is DNSCrypt, and it is
not protection against traffic analysis. DoH on 443 looks like ordinary HTTPS.

## Files

| File | Purpose |
|---|---|
| `index.html`, `style.css` | The page. |
| `app.js` | Connects the page to the logic. Text from a file or from the user is put on the page with `textContent` only. |
| `core.js` | Logic without any page access: DNS stamp decoding and encoding, validation, generation of the TOML. It also runs in Node. |
| `sample-resolvers.json` | Nine made-up entries for the prototype. |
| `tests/core.test.js` | Tests of the logic. |
| `tests/ui.test.js` | Tests that drive the page in a simulated browser (jsdom). |
| `tests/browser.html` | The same kind of steps in a real browser. Open it over HTTP (see below). |
| `tests/fuzz.js`, `tests/verify-toml.py` | Fuzzing of the stamp parser and of the configuration generator, and an independent parse of every accepted configuration. |
| `tests/stamp-parity.js`, `tests/stamp-parity/stampcheck.go` | Compares the stamp parser of the page with the stamp parser of the daemon. |

## Tests

None of the tests is installed or run by the SDK build. Each one writes its result to the
terminal and ends with a non-zero exit status on failure (`browser.html` writes it to the page).

    node tests/core.test.js
    node tests/core.test.js --list resolvers.json --write /tmp/gen   # real data, writes configurations

The `--list` run decodes and encodes every stamp of a real list and requires the
same stamp back. The `--write` run writes the configurations of five scenarios so
that they can be given to `dnscrypt-proxy -config <file> -check`.

    npm install jsdom            # in any directory, not in this one
    NODE_PATH=<that directory>/node_modules node tests/ui.test.js

    node tests/fuzz.js --list resolvers.json --seed 1 --out cases.jsonl
    python3 tests/verify-toml.py cases.jsonl

    # parity needs a reference checker, built from the vendored go-dnsstamps of the
    # dnscrypt-proxy source: copy tests/stamp-parity/stampcheck.go to <source>/stampcheck/main.go
    # and run: go build -mod=vendor -o stampcheck ./stampcheck
    node tests/stamp-parity.js --check ./stampcheck --list resolvers.json --n 300000 --seed 1

    python3 -m http.server 8000      # in this directory, then open http://127.0.0.1:8000/tests/browser.html

### Results of the last run

Linux (WSL2) with Node 22, a list of 1232 entries downloaded on the day, and dnscrypt-proxy 2.1.21:

- `tests/core.test.js`: 34 checks passed. The real list was decoded and encoded again
  (379 DNSCrypt, 405 DoH, 315 relays, 130 ODoH targets, 3 ODoH relays) and every stamp
  came back unchanged. The ports in the stamps of 694 DNSCrypt servers and relays matched the list.
- `tests/ui.test.js`: 16 steps passed. They cover the three ways to add a server, the
  filters, Oblivious DoH with and without a relay, relays, the limit of 8 servers, the
  options, and a list whose names and descriptions contain HTML.
- `tests/browser.html` in Microsoft Edge 158 (headless, over HTTP): 14 steps passed, no script
  errors.
- `tests/stamp-parity.js`, three seeds of about 297000 stamps each (the list, hand-made edge
  cases and damaged copies): the page never accepted a stamp that the daemon refuses. The page is
  stricter in about 9700 cases per run, almost all because it also refuses text that is not valid UTF-8,
  which the daemon does not check.
- `tests/fuzz.js`, three seeds with 200000 stamps and 40000 random settings each: no crash, no
  accepted stamp that did not survive decode and encode, and all 44,800 or so accepted configurations
  were parsed by Python `tomllib` without an injected key or table.
- 60 of the generated configurations were given to the daemon with `-check`, and all 60 were
  accepted. An earlier run of the same check found one configuration that the daemon refused
  (a DoH stamp that the page accepted). The stamp parser was changed to follow the rules of the
  daemon, and the parity test was added to find such differences.
- Configurations of five scenarios were also used for real queries with an unpatched dnscrypt-proxy:
  servers from the list (DNSCrypt and DoH), a DoH address entered by hand
  (`https://cloudflare-dns.com/dns-query`), Anonymized DNSCrypt through a named relay (with TCP) and
  Oblivious DoH through an automatically chosen relay. That was run on an earlier version of the
  page and was not repeated for this one.

## Limits

- It does not talk to a daemon. It cannot show whether a server is reachable, its
  measured delay or the current state.
- Stamps for DNS-over-TLS and DNS-over-QUIC are refused. The checks of other stamp
  types follow the stamp parser of dnscrypt-proxy 2.1.21 (see `tests/stamp-parity.js`).
  They only show that the daemon can read a stamp, not that the server works.
- Port changes are limited to DNSCrypt servers and relays. For DoH the port is part
  of the address. Only port 443 was tried against real DoH servers.
- It was tried in a simulated browser (jsdom) and in one real browser engine (Microsoft Edge 158,
  headless, 14 steps over HTTP). Firefox, Safari and small screens were not tried.