# Integration notes for dnscrypt-proxy

This page compares what the existing DNS-over-TLS integration in this SDK
expects from a DNS daemon with what dnscrypt-proxy provides. It is meant to
shorten the review for engineers who would decide whether and how this package
could become a KeeneticOS component. It does not describe, and does not depend on,
any closed-source part of KeeneticOS.

## Sources

Everything here comes from public material:

- `package/net/stubby/patches/900-ndm-integration.patch` in this repository.
  It shows what the stubby daemon was changed to do. Stubby is the DNS-over-TLS
  daemon of this SDK.
- The public support article "DoH and DoT proxy servers for DNS requests
  encryption" (support.keenetic.com), for the user-facing behaviour.
- The source of dnscrypt-proxy 2.1.21 and this package's own tests.

No statement here is based on the inside of a firmware image. How the system
starts, configures and supervises DNS daemons is not documented in this
repository, so this page makes no claim about it. Where a row says "needs the
system side", that is a question for the people who know it.

## Comparison

"Verified" means it was run. All runs were on x86_64 Linux, apart from the qemu
runs, which are noted. Nothing was run on a Keenetic device.

| Expectation | What stubby does with the patch | dnscrypt-proxy 2.1.21 upstream | This package | Status |
|---|---|---|---|---|
| Log to syslog, with a level | Sends all output to syslog and drops messages above a level. | `use_syslog = true` (facility DAEMON) and a `log_level` setting. | `use_syslog = true`. | Met. Log lines were seen in the system journal. Not tried with the Keenetic syslog. |
| Run as an unprivileged user | New options `-U` and `-G` set the user and group after start. | `user_name`. It needs root, drops groups, sets gid and uid, and starts itself again as a child. | Not set. It is unknown whether the system has a suitable user. | Partly. `user_name` removes all capabilities, so it cannot be combined with `socket_mark`. The package refuses that combination. See "Unprivileged user and socket mark". |
| Mark outgoing sockets (`SO_MARK`) so routing rules can match them | Keeps `CAP_NET_ADMIN` across the user switch. The patch comment says "For SO_MARK". | No such option. | `patches/001-add-socket-mark.patch` adds `socket_mark`. | Met on x86_64 only. See "Socket mark" below. |
| Restart on persistent failure | After more than 30 failed requests and 150 seconds without a success, the process logs "too many failed requests, try to reload process" and sends itself `SIGINT`. | Nothing similar. With no reachable server it logs "waiting for at least one server to be reachable" and keeps trying. | Nothing added. | Missing. The stubby patch exits on purpose, which only helps if something starts the process again. For dnscrypt-proxy a health check on the system side could do it, for example a test query to the listen address and a restart when it fails. Not tried. |
| Clean stop and reload | Not shown in the patch. | `SIGINT` and `SIGTERM` stop it. `SIGHUP` reloads the plugin lists. `-pidfile` writes the process id. `-check` validates a configuration and exits. | Nothing added. | Met. `SIGTERM` was verified to stop it with the log line "Stopped.". `-check` returned 0 on a good file and a non-zero code on a bad one. |
| Configuration handed over by the system | Not shown in the patch. | A TOML file given with `-config`. | A default file in `/etc/dnscrypt-proxy`. | Needs the system side to write the effective file, for example to `/tmp`. `gui/core.js` shows one way to generate it. |
| Machine-readable lists for a settings page | Not applicable. | `-list -json` and `-list-all -include-relays -json` print servers and relays with name, protocol, ports, DNSSEC, no-log and no-filter flags and the stamp. | Used by the `gui/` templates. | Met. Verified on the real lists: 1233 entries, and every stamp survives decode and encode unchanged. |
| Per-client profile | The patch reads a 4-byte value from an additional record of type 65517 in a query and passes it to the resolver library as `sdns_profile`. | Nothing similar. | Nothing. | Open. The purpose is not documented in this repository, so no equivalent is proposed here. |
| "Connection interface" field on the DoT and DoH pages | Not shown in the patch. | Not an option. | `socket_mark` plus a routing rule can achieve it. | Needs the system side to map an interface to a mark. Verified only that marked traffic can be steered or dropped by a rule. |
| Limit of 8 servers, ordered by response time | Not shown in the patch. | No limit. Servers are balanced by measured response time (default strategy WP2). | No limit in the daemon. The `gui/` templates apply the limit of 8. | A product decision. |

## Socket mark

Patch `001-add-socket-mark.patch` adds the option `socket_mark` to dnscrypt-proxy.
It is applied automatically by the package build.

Sockets that get the mark:

- DNSCrypt queries to servers and relays, over UDP and TCP, including the pool of
  reused UDP connections.
- DNS-over-HTTPS connections over HTTP/1.1 and HTTP/2, and the UDP socket used
  for HTTP/3.
- Downloads of resolver lists.
- Bootstrap lookups of server names with plain DNS.
- The last-resort lookup through the system resolver (`net.DefaultResolver`).
- The network probe.

Sockets that do not get the mark: the listening sockets, forwarding rules
(`forwarding_rules`), connections through the `proxy` option, and the
captive-portal listener.

The option fails closed. If the mark cannot be set, the connection fails and is
never sent unmarked. At start the daemon tries to set the mark once and stops with
a message if `CAP_NET_ADMIN` is missing.

What was verified:

- Five unit tests for the patch. They read the mark back from the sockets
  (`SO_MARK`) for TCP, UDP, `Dialer`, `ListenConfig` and the default resolver.
- On a running daemon, `ss -e` showed `fwmark:0x1234` on the sockets that go to
  upstream servers.
- With a routing rule that sends the mark to a blackhole route, the daemon could not
  fetch the resolver lists. The error was `connect: invalid argument`, and the bootstrap
  lookups failed the same way. Without the rule, or without the option, it worked.
- The package builds for `linux/arm64`, `linux/mipsle` and `linux/mips` with the
  patch, and for Windows, macOS and FreeBSD (where the option is refused with a
  message).

What could not be verified:

- The mark under qemu. `qemu-user` answers `protocol not available` to `SO_MARK`
  for all three emulated architectures, while other socket options work. This is
  most likely a limit of the emulator and not of the code. The option is off by
  default, so the qemu runs below do not touch it.
- Kernel 4.9 on a real device, and routing policies on a real router.
- The blackhole test did not show the last-resort lookup failing. The test machine's
  system resolver is a local address, which routing rules do not redirect. The
  mark on that path is covered by a unit test only.

The patch changes upstream code. The upstream project states that it does not
accept contributions written by AI (`AI-POLICY.md`), so this patch is not
intended for upstream.

## Unprivileged user and socket mark

`user_name` and `socket_mark` exclude each other, because switching user drops
`CAP_NET_ADMIN`. The starter can instead run the daemon as an unprivileged user
that keeps only that one capability. This was verified on x86_64 with `setpriv`:

    setpriv --reuid=65534 --regid=65534 --clear-groups \
            --inh-caps=+net_admin --ambient-caps=+net_admin \
            --bounding-set=-all,+net_admin \
            dnscrypt-proxy -config <file>

The process ran as uid 65534 with only `CAP_NET_ADMIN` (`CapEff`, `CapPrm`, `CapAmb`
and `CapBnd` all `0x1000`), answered queries, and its upstream sockets carried the
mark. The same start without the capability stopped with the message that
`CAP_NET_ADMIN` is required. How the system starts its daemons is not known here, so
whether it can start dnscrypt-proxy this way is a question for the system side.

## Behaviour that is easy to miss

- **Servers chosen by name skip the property filters.** `require_dnssec`,
  `require_nolog` and `require_nofilter` apply only while `server_names` is empty
  (`proxy.go`). A server listed in `server_names` is used even if it advertises
  none of them. The `gui/` templates show a note for this.
- **The system resolver is still a last resort.** With `ignore_system_dns = true`,
  the proxy resolves server names with the bootstrap resolvers, which are plain DNS.
  If none of them answers it logs "Trying with the system resolver as a last resort"
  and uses the system resolver anyway. If the system resolver forwards to this proxy,
  that can loop. There is no option to switch this off.
- **No network means no answer.** When no upstream server can be reached, the proxy stays up and
  uses no CPU, but it does not answer client queries (in a test, none within 12 seconds, and no
  SERVFAIL). If the system resolver forwards only to this proxy, name resolution stops until a server
  is reachable again. A fallback is a decision for the system side.
- **Bootstrap lookups are plain DNS.** They reveal that the router is looking up
  the hosts of the resolver lists, and nothing more. The lists themselves are checked
  with a signature.
- **The port is part of the stamp.** The port of a DNSCrypt server or relay is chosen
  by its operator. Rewriting it in a stamp helps only if the server listens there. A
  test with a changed port on a server that did not listen there timed out. Most
  servers in the public lists use 443 (345 of 401 DNSCrypt entries), and the
  DoH entries use it in their address as well. Port 443 may get past port-based blocking. It does not protect
  against traffic analysis.
- **DNSCrypt over UDP and relays.** Anonymized DNSCrypt sends large UDP packets. In
  one test environment they were dropped and the daemon could not use the relayed
  route over UDP. It worked with `force_tcp = true`. Whether it works on a router
  network is unknown.
- **HTTP/3.** With `http3 = true` a DoH server is first reached over HTTP/2 and the
  proxy switches to HTTP/3 when the server announces it. With `http3_probe = true`
  it tries HTTP/3 first. Both were checked by looking at the sockets: a UDP socket
  and the log line `Protocol: h3`, and with the probe no TCP connection to port 443.
  This needs UDP port 443.

## Features that were considered and not added

- **Encrypted Client Hello (ECH).** The Go version that builds this package can do
  ECH as a client (`tls.Config.EncryptedClientHelloConfigList`), but dnscrypt-proxy
  2.1.21 does not use it. Using it would need new code that fetches the ECH
  configuration of a server from its HTTPS DNS record, and that lookup would
  have to be trusted. That is security-sensitive code that would differ from upstream,
  so it was not written.
- **Discovery of Designated Resolvers (RFC 9462).** dnscrypt-proxy is configured
  with explicit server stamps and has no discovery step, so there is nothing for the
  mechanism to replace. It is not implemented.
- **Smaller binary.** In a minimal test program, HTTP/3 adds about 2.4 to 2.6 MB
  (about 0.6 MB after `xz`) and the WebSocket library of the unused monitoring
  interface about 0.7 MB (about 0.2 MB after `xz`). HTTP/3 is kept because it is a
  wanted feature. Removing the monitoring interface would need a larger patch for
  about 0.2 MB in the image, so it was not done.

## Remaining questions for the system side

- How is a DNS daemon started, stopped and supervised, and can it be given one
  capability?
- Should several encrypted DNS services run at the same time, and which one
  answers?
- Where would the effective configuration be written, and who validates it?
- Is a per-client profile needed, and what would it look like?
- Which models have the flash and memory for a 12 to 14 MB binary (3.2 to 3.4 MB
  after `xz`)?
