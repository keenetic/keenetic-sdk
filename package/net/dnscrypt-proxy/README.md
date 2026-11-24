# dnscrypt-proxy

Package for [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy) 2.1.21
(ISC license). It adds an encrypted DNS client to the firmware image.
The daemon supports:

- DNSCrypt v2
- Anonymized DNSCrypt
- DNS-over-HTTPS (DoH)
- Oblivious DoH (ODoH)

This is a plain SDK package, like `stubby` (DNS-over-TLS) and `https-dns-proxy`
(DNS-over-HTTPS). It provides the daemon and a default configuration.
It does not provide a KeeneticOS component: NDM sources are not part of this
repository (see "Integration" below).

This package is an AI-assisted research contribution, submitted for review. It
has not had an independent security audit, has not been built as part of a full
SDK image, and has not been run on a router.

## Build requirements

The SDK has no Go toolchain package. The daemon is built with the Go
toolchain installed on the build host:

- The Go version in the `go` line of upstream `go.mod` (1.27.4 for 2.1.21) or
  newer, available in `PATH` or via `DNSCRYPT_PROXY_GO=/path/to/go`.
  The build uses `GOTOOLCHAIN=local`, so an older Go fails with a clear error
  instead of downloading a toolchain.
- No network access is needed for the Go build. Upstream vendors all
  dependencies. The build uses `-mod=vendor` and `GOPROXY=off`.
- The binary is pure Go (`CGO_ENABLED=0`) and statically linked, so the
  target C library and the SDK C toolchain are not used.
- `-buildvcs=false` and `-trimpath` are set. Without `-buildvcs=false`, Go
  records the git revision of the enclosing SDK checkout in the binary.

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

Measured with upstream 2.1.21 and Go 1.27.4:

| Target   | Stripped binary | `xz -9e` |
|----------|-----------------|----------|
| arm64    | 11.9 MB         | 3.4 MB   |
| mipsle   | 14.2 MB         | 3.3 MB   |

The `xz` column approximates the cost inside the xz SquashFS image.
For comparison, a stock KN-1812 firmware (5.01.C.10.0-0) is 20.6 MB.

Resident memory of a `linux/amd64` build was 40 MB (14 threads) one minute after
start with the default configuration and no client load. This was not measured on
a target CPU, and 32-bit MIPS builds will differ. Check the flash and RAM size
of the target before selecting the package.

## Runtime

`/etc` is read-only, so all state is kept in `/tmp/dnscrypt-proxy`. The
directory must exist before the daemon starts:

    mkdir -p /tmp/dnscrypt-proxy
    dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml

Useful options for process management: `-pidfile <file>`, `-check`
(validate the configuration and exit), `-version`.

## Default configuration

`files/dnscrypt-proxy.toml`:

- Listens on `127.0.0.1:5359` only. The system resolver is expected to forward
  to it. The monitoring web interface is explicitly disabled (upstream's
  defaults for it include the credentials `admin`/`changeme`).
- DNSCrypt and DoH servers are enabled, IPv6 servers are disabled.
- ODoH is supported by the daemon but disabled by default. It only works through
  a relay, and without a relay the daemon logs `No relay defined for [...]`
  repeatedly. The ODoH resolver lists are present in the file, commented out.
- Anonymized DNSCrypt is supported but has no routes by default, so queries go
  directly to the resolver. Routes are a policy choice (relay and resolver
  should be operated by different entities), so none is preselected. See the
  `[anonymized_dns]` example at the end of the file.
- `require_dnssec`, `require_nolog` and `require_nofilter` are `true`. This
  leaves about 470 servers with the upstream lists at the time of testing.
  These flags select resolvers by what they advertise. They do not validate
  answers in the proxy.
- Logs go to syslog. Query logging is off.
- Resolver lists are downloaded at start and verified with the upstream
  minisign key.
- `ignore_system_dns = true`, so the proxy never resolves its own upstream
  names through the resolver that forwards to it.
- `user_name` is not set, because it is not known whether the firmware has an
  unprivileged user to switch to. The listen port is above 1024 and the
  configuration file is world-readable, so the integration can start the
  daemon as an unprivileged user.

## Security and privacy notes

- `bootstrap_resolvers` and `netprobe_address` are third-party public
  resolvers (9.9.9.9 and 1.1.1.1) queried over plain DNS (UDP port 53). They are
  only used to find the addresses of the resolver list hosts and to detect
  connectivity. The lists themselves are verified by signature. Replace them
  with resolvers you trust.
- DoH certificates are verified against the system store. The package depends on
  `ca-certificates`, which installs one `.crt` file per CA in
  `/etc/ssl/certs` and no bundle file. Go reads that directory. This layout
  was tested on a PC with 121 CA files in a directory (SSL_CERT_DIR); with an
  empty directory the daemon refuses to start (fails closed). It was not tested
  on a device.
- Anonymized DNSCrypt sends large UDP packets through relays. If UDP
  fragments are dropped on the path, the daemon cannot use the anonymized
  route and, with `skip_incompatible = true`, ignores the resolver. Setting
  `force_tcp = true` avoids this.
- This package does not make DNS anonymous or leak-free. Other DNS clients on
  the network can bypass the proxy, the resolver operator still sees the queries
  unless a relay is used, and bootstrap queries are plain DNS.
- `govulncheck` reports one vulnerability in the vendored dependencies of
  2.1.21: GO-2026-6278 in `github.com/gorilla/websocket` v1.5.3, used by the
  monitoring web interface, which is disabled here. It is an upstream
  dependency and is not changed by this package.
- Dependency licenses (vendored, 33 modules): MIT, BSD, ISC, Apache-2.0,
  zlib-style, and MPL-2.0 for `hashicorp/go-immutable-radix` and
  `hashicorp/golang-lru`. The licenses were identified by reading the license
  files in the vendored sources, not by a formal review. MPL-2.0 has file-level
  copyleft terms, so redistribution and notice requirements should be confirmed
  by someone qualified before this is shipped in an image. The source of these
  modules is part of the upstream source tarball.

## Integration

Nothing in this package starts the daemon, adds it to a component list, points
the system resolver at it, or exposes it in the web interface or CLI.
How the existing `stubby` and `https-dns-proxy` packages are started and
configured is not documented in this repository, so this package makes no
assumption about it.

A user-facing feature would need integration work on the Keenetic side, in
components that are not part of this repository. This package does not request
or depend on access to that code. Until such integration exists, the daemon
can only be started and configured by hand.

## Verification

Done on Ubuntu (WSL2, x86_64) with upstream 2.1.21 and Go 1.27.4:

Passed:

- The source tarball downloaded from the URL in `Makefile` matches `PKG_HASH`.
- Cross-compilation for `linux/arm64`, `linux/mipsle` and `linux/mips` with the
  flags used by `Makefile`, with empty Go caches and `GOPROXY=off`. The binaries
  are statically linked ELF files without a program interpreter. Two builds
  with empty caches produced identical files.
- `-buildvcs=false` removes the git revision that Go otherwise embeds when the
  source sits inside a git repository.
- `dnscrypt-proxy -check` accepts `files/dnscrypt-proxy.toml`.
- With a `linux/amd64` build and this configuration, A queries were answered on
  the local port: with the default configuration, with DNSCrypt only (240
  DNSCrypt and 0 DoH server log lines), with DoH only (154 DoH and 0 DNSCrypt),
  with Anonymized DNSCrypt through explicit relays (`force_tcp = true`), and
  with ODoH through an automatically chosen relay.
- `make prepare-tmpinfo` in the SDK parses the package.
- `Package/dnscrypt-proxy/install` places the binary (`0755`) and the
  configuration (`0644`) in the expected paths. `Build/Compile` expands to the
  expected command for each of the three architectures and fails with an error
  for any other.

Failed or inconclusive:

- Anonymized DNSCrypt over UDP did not work in the test environment: the proxy
  detected dropped UDP fragments and ignored the resolver (WSL2 behind NAT).
  It worked with `force_tcp = true`. Whether UDP works on a router network was
  not tested.

Not done:

- A full SDK build (`make package/net/dnscrypt-proxy/compile`) or an image build.
- Running on a Keenetic device, including MIPS binaries (they were only
  cross-compiled) and the `ca-certificates` package contents.
