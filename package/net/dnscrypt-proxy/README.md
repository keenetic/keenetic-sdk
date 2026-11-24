# dnscrypt-proxy

Package for [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy) 2.1.21
(ISC license). It adds an encrypted DNS client to the firmware image.
The daemon supports:

- DNSCrypt v2, with post-quantum key exchange (PQDNSCrypt) when the server supports it
- Anonymized DNSCrypt
- DNS-over-HTTPS (DoH), over HTTP/2 and HTTP/3
- Oblivious DoH (ODoH)
- servers of your own, given as DNS stamps

This is a plain SDK package, like `stubby` (DNS-over-TLS) and `https-dns-proxy`
(DNS-over-HTTPS). It provides the daemon and a default configuration.
It does not provide a KeeneticOS component: NDM sources are not part of this
repository (see `INTEGRATION.md`).

This package is an AI-assisted research contribution, submitted for review. It
has not had an independent security audit, has not been built as part of a full
SDK image, and has not been run on a router.

## Contents of this directory

| Path | Purpose |
|---|---|
| `Makefile` | Package definition. |
| `files/dnscrypt-proxy.toml` | Default configuration, installed in `/etc/dnscrypt-proxy`. |
| `patches/001-add-socket-mark.patch` | Adds the option `socket_mark` (see `INTEGRATION.md`). |
| `INTEGRATION.md` | What the existing DNS-over-TLS integration expects from a daemon, and how dnscrypt-proxy compares. |
| `gui/` | Design templates and a working prototype of a settings page. Not installed. See `gui/README.md`. |
| `tests/` | Scripts that test the daemon as a binary on a Linux machine. Not installed. See `tests/README.md`. |

The package also needs `package/devel/golang`, a host-only package that is part of
the same change (see below).

## Build requirements

The daemon is written in Go. The SDK had no Go toolchain, so this change adds
`package/devel/golang`:

- It downloads the official Go binary release (`go1.27.4`, linux, amd64 or arm64
  to match the build host) from `dl.google.com` and checks its SHA-256.
  It is installed into `staging_dir/host/lib/go`, is marked build-only, and puts
  nothing on the device.
- The version has to satisfy the `go` line of the `go.mod` of dnscrypt-proxy
  (1.27.4 for 2.1.21). Keep the two in step when updating. The build uses
  `GOTOOLCHAIN=local`, so a Go that is too old fails with a clear error instead
  of downloading another toolchain.
- It is written for a build host that is x86_64 or aarch64 Linux. It is meant to stop with
  an error on any other host. That was not tried.

To use a Go of your own, set `DNSCRYPT_PROXY_GO=/path/to/go` and remove
`PKG_BUILD_DEPENDS:=golang/host` from the `Makefile`, otherwise the host Go is
still downloaded.

Other build settings:

- No network access is needed for the Go build. Upstream vendors all dependencies.
  The build uses `-mod=vendor` and `GOPROXY=off`.
- The binary is pure Go (`CGO_ENABLED=0`) and statically linked, so the target C
  library and the SDK C toolchain are not used.
- `-buildvcs=false` and `-trimpath` are set. Without `-buildvcs=false`, Go records
  the git revision of the enclosing SDK checkout in the binary.

Architecture mapping:

| SDK `ARCH` | `GOARCH` | Notes              |
|------------|----------|--------------------|
| `aarch64`  | `arm64`  |                    |
| `mipsel`   | `mipsle` | `GOMIPS=softfloat` |
| `mips`     | `mips`   | `GOMIPS=softfloat` |

Compatibility with the Go requirements
(<https://go.dev/wiki/MinimumRequirements>): Go needs Linux 3.2 or later and
MIPS32r1 or later. All targets in this SDK use kernel 4.9, and every MIPS
target is built with `-mips32r2`. The generic kernel configuration has the MIPS
FPU emulator disabled, which is why the MIPS builds use `softfloat`.

## Size and memory

Measured with upstream 2.1.21 and Go 1.27.4, built as the `Makefile` does:

| Target   | Stripped binary | `xz -9e` |
|----------|-----------------|----------|
| arm64    | 12.1 MB         | 3.4 MB   |
| mipsle   | 14.2 MB         | 3.3 MB   |
| mips     | 14.2 MB         | 3.2 MB   |

The `xz` column approximates the cost inside the xz SquashFS image. For comparison,
a stock KN-1812 firmware (5.01.C.10.0-0) is 20.6 MB.

In a minimal test program, HTTP/3 adds about 2.4 to 2.6 MB to a binary (about 0.6 MB
after `xz`) and the WebSocket library of the unused monitoring interface about
0.7 MB (about 0.2 MB after `xz`). The HTTP/3 code is kept because it is a wanted
feature.

Resident memory of a `linux/amd64` build was about 22 MB (14 threads, 11 open files, about
1% of one core) in an 8 minute test with three pinned servers and about 40 queries per second.
With the default configuration, which probes about 340 servers, it was about 40 MB one minute
after start with no client load. Neither was measured on a target CPU, and 32-bit MIPS builds will
differ. Check the flash and RAM size of the target before selecting the package.

## Runtime

`/etc` is read-only, so all state is kept in `/tmp/dnscrypt-proxy`. The starter
has to create the directory before the daemon starts:

    mkdir -p /tmp/dnscrypt-proxy
    dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml

Useful options: `-pidfile <file>`, `-check` (validate the configuration and exit),
`-version`, `-list-all -include-relays -json` (servers and relays as JSON).

## Default configuration

`files/dnscrypt-proxy.toml`:

- Listens on `127.0.0.1:5359` only. The system resolver is expected to forward
  to it. The monitoring web interface is explicitly disabled (upstream's defaults
  for it include the credentials `admin`/`changeme`).
- DNSCrypt and DoH servers are enabled, IPv6 servers are disabled.
- Anonymized DNSCrypt is supported but has no routes by default, so queries go
  directly to the resolver. Routes are a policy choice (relay and resolver should
  be operated by different entities), so none is preselected. See the
  `[anonymized_dns]` example at the end of the file.
- ODoH is supported but disabled. It only works through a relay, and without a relay
  the daemon logs `No relay defined for [...]`. The ODoH resolver lists are in the
  file, commented out.
- `force_tcp = false` and `http3 = false`. Both can be turned on. The port of a
  server is part of its stamp and is chosen by the operator, so a port cannot be
  chosen in the configuration. Most servers and relays in the public lists use 443.
- Servers of your own can be added as `[static]` entries with their DNS stamp, and
  named in `server_names`. The file contains an example with placeholder stamps.
- `require_dnssec`, `require_nolog` and `require_nofilter` are `true`. These
  select resolvers by what they advertise, and only while `server_names` is
  empty. They do not validate answers in the proxy.
- Logs go to syslog. Query logging is off.
- Resolver lists are downloaded at start and verified with the upstream
  minisign key.
- `user_name` is not set, because it is not known whether the firmware has an
  unprivileged user to switch to. The listen port is above 1024 and the
  configuration file is world-readable, so the integration can start the
  daemon as an unprivileged user.

## Protocols and what is not included

| Feature | Status |
|---|---|
| DNSCrypt v2 and PQDNSCrypt | Supported by the daemon. PQDNSCrypt is on by default upstream. |
| Anonymized DNSCrypt | Supported by the daemon. Needs routes. |
| DoH over HTTP/2 | Enabled. |
| DoH over HTTP/3 | Supported. Off by default. `http3 = true` switches to HTTP/3 once a server announces it, `http3_probe = true` tries it first. Checked by looking at the sockets. Needs UDP port 443. |
| Oblivious DoH | Supported by the daemon. Off by default. Needs a relay. |
| Encrypted Client Hello | Not included. The daemon does not use it. See `INTEGRATION.md`. |
| Discovery of Designated Resolvers (RFC 9462) | Not included. It does not fit a daemon that is configured with explicit stamps. See `INTEGRATION.md`. |
| Socket mark for routing | Added by `001-add-socket-mark.patch`. Off by default. Linux only. |

## Security and privacy notes

- `bootstrap_resolvers` and `netprobe_address` are third-party public
  resolvers (9.9.9.9 and 1.1.1.1) queried over plain DNS (UDP port 53). They are
  only used to find the addresses of the resolver list hosts and to detect
  connectivity. The lists themselves are verified by signature. Replace them
  with resolvers you trust.
- `ignore_system_dns = true` does not stop the system resolver completely. If no
  bootstrap resolver answers, the daemon uses the system resolver as a last resort.
  If the system resolver forwards to this proxy, that can loop.
- A server that is named in `server_names` is used even if it does not meet
  `require_dnssec`, `require_nolog` or `require_nofilter`.
- DoH certificates are verified against the system store. The package depends on
  `ca-certificates`, which installs one `.crt` file per CA in `/etc/ssl/certs`
  and no bundle file. Go reads that directory. This layout was tested on a PC
  with 121 CA files in a directory (`SSL_CERT_DIR`). With an empty directory the
  daemon refuses to start (fails closed). It was not tested on a device.
- Anonymized DNSCrypt sends large UDP packets. If UDP fragments are dropped on the
  path, the daemon cannot use the anonymized route and, with
  `skip_incompatible = true`, ignores the resolver. Setting `force_tcp = true`
  avoids this.
- This package does not make DNS anonymous or leak-free. Other DNS clients on
  the network can bypass the proxy, the resolver operator still sees the queries
  unless a relay is used, and bootstrap queries are plain DNS.
- `govulncheck` reports GO-2026-6278 in `github.com/gorilla/websocket` v1.5.3, which
  is used by the monitoring web interface. This interface is disabled here. Reading
  the code shows that the weak random number is used only for the mask key of frames
  that a WebSocket **client** sends (`isServer` is false), and dnscrypt-proxy only
  uses the server side (`websocket.Upgrader`) and never calls `websocket.Dial`. As far
  as the code shows, the affected path cannot run. The advisory sources also disagree
  about which versions are affected. v1.5.3 is the latest release of the library and
  upstream uses it. The dependency is not changed by this package.
- Dependency licenses (vendored, 33 modules) were read from the license files, not
  reviewed: MIT, BSD, ISC, Apache-2.0, zlib-style, and MPL-2.0 for
  `hashicorp/go-immutable-radix` and `hashicorp/golang-lru`. MPL-2.0 has
  file-level copyleft terms, so redistribution and notice requirements should be
  confirmed by someone qualified before this is shipped in an image. The source of
  these modules is part of the upstream source tarball.

## Verification

Done on Ubuntu (WSL2, x86_64) with upstream 2.1.21 and Go 1.27.4. Nothing was run
on a Keenetic device. The scripts and tests that can be repeated are in `tests/` and
`gui/tests/`. The numbers of the last run, with their dates and limits, are in the
description of the pull request that proposes this package.

Passed:

- The source tarball downloaded by the SDK matches `PKG_HASH`.
- `make prepare-tmpinfo` parses both packages, and `package/net/dnscrypt-proxy/prepare`
  applies the patch. `package/devel/golang/host/compile` installs Go 1.27.4 into the
  host staging directory, and the downloaded archive matches its hash.
- The compile commands of the `Makefile` were run for `aarch64`, `mipsel` and `mips`
  on that source with the Go from the staging directory. Static ELF files without a
  program interpreter came out, without a git revision inside. `Build/Compile` fails with
  an error for any other architecture. `Package/dnscrypt-proxy/install` places the binary
  (`0755`) and the configuration (`0644`) in the expected paths.
- Under `qemu-user` (`qemu-aarch64`, `qemu-mipsel`, `qemu-mips`), the three
  binaries printed `2.1.21` for `-version`, accepted the shipped configuration with
  `-check`, and answered a real A query. This shows that the instruction sets and the
  `softfloat` setting work. It is not a device test.
- On `linux/amd64`, the upstream test suite passes as an unprivileged user (uid 65534), on the
  patched and on the unpatched source (patched: 50 top-level tests pass, 2 skip because they need
  `CAP_NET_ADMIN`). As root, `TestNewSource` fails on both, because its cases that make a
  cache file unreadable cannot fail for root. `go vet`, `gofmt` and the race detector (unit tests
  only) report nothing for the new files. `staticcheck` (4 findings) and `gosec` (116 findings)
  report the same number of findings on the unpatched and the patched source.
- On `linux/amd64`, queries were answered with the default configuration, with DNSCrypt only, with
  DoH only, with Anonymized DNSCrypt through relays (with `force_tcp = true`), with ODoH through an
  automatically chosen relay, and with a DoH address entered by hand. HTTP/3 was used when `http3`
  was on. These runs were made on an earlier build of the same package and were not repeated in the
  last run.
- `tests/leak-test.sh`: none of 15 query names appeared in clear text on `eth0`, and the same search
  found a plain query that was sent on purpose. The plain DNS that the daemon sent went to 9.9.9.9
  (bootstrap and list download host names). Relays and ODoH were not part of this test.
- `tests/robustness-test.sh`: a load test with SIGHUP (3 minutes, about 40 queries per second, three
  pinned servers) answered every query. Memory, threads and open files stayed flat. Hostile input
  (6000 malformed UDP packets, a compression loop, a name longer than 255 bytes, 400 idle TCP
  connections) did not stop the daemon. `SIGTERM` gave exit status 0, and after `kill -9` the first
  answer came after about 3.5 s. Without any network the daemon stayed alive and used no CPU, but it
  did not answer queries within 12 s (clients time out, there is no SERVFAIL).
- The templates in `gui/` (see `gui/README.md`): logic, page, parity-with-daemon, fuzz and real-browser
  tests passed, and 60 generated configurations were accepted by `dnscrypt-proxy -check`.
- The SHA-256 of the Go archives in `package/devel/golang` matches the value published on
  go.dev and the file on dl.google.com. Both belong to the same publisher.

Failed or inconclusive:

- Under `qemu-user`, setting `SO_MARK` fails with `protocol not available` on all
  three architectures, while other socket options work. The mark was tested on
  `linux/amd64` only.
- Anonymized DNSCrypt over UDP did not work in the test environment: the proxy
  detected dropped UDP fragments and ignored the resolver (WSL2 behind NAT).
  It worked with `force_tcp = true`. Whether UDP works on a router network was
  not tested.
- A single `make package/net/dnscrypt-proxy/compile` could not be completed in the
  test environment. The SDK's toolchain step stopped with error 126 while building the
  `libgcc` package. The cause was not investigated, and the steps above were run
  one by one instead.

Not done:

- A full SDK build or an image build.
- Running on a Keenetic device, including the MIPS binaries on a real CPU, and the
  contents of the `ca-certificates` package on a device.
- The templates in `gui/` were tried in one browser engine (Edge, Chromium based), not in Firefox
  or Safari, and not on a small screen.
- Runs of hours, and a leak test with relays or ODoH.