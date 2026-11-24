# dnscrypt-proxy

Package for [dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy) (ISC license).
It adds an encrypted DNS client to the firmware image. Supported protocols:

- DNSCrypt v2
- Anonymized DNSCrypt
- DNS-over-HTTPS (DoH)
- Oblivious DoH (ODoH)

This is a plain SDK package, like `stubby` (DNS-over-TLS) and `https-dns-proxy`
(DNS-over-HTTPS). It provides the daemon and a default configuration.
It does not provide a KeeneticOS component: the NDM side is closed source and
is not part of this SDK (see "Integration" below).

## Build requirements

The SDK has no Go toolchain package. The daemon is built with the Go
toolchain installed on the build host:

- Go version listed in the `go` line of upstream `go.mod` (1.27.4 for 2.1.21)
  or newer, available in `PATH` or via `DNSCRYPT_PROXY_GO=/path/to/go`.
- No network access is needed for the Go build. Upstream vendors all
  dependencies and the build uses `-mod=vendor`.
- The binary is pure Go (`CGO_ENABLED=0`) and statically linked, so the
  target C library and the SDK C toolchain are not used.

Architecture mapping:

| SDK `ARCH` | `GOARCH` | Notes              |
|------------|----------|--------------------|
| `aarch64`  | `arm64`  |                    |
| `mipsel`   | `mipsle` | `GOMIPS=softfloat` |
| `mips`     | `mips`   | `GOMIPS=softfloat` |

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

Default configuration (`files/dnscrypt-proxy.toml`):

- Listens on `127.0.0.1:5359`. The system resolver is expected to forward to it.
- DNSCrypt, DoH and ODoH servers are enabled, IPv6 servers are disabled.
- `ignore_system_dns = true`, so the proxy never resolves its own upstream
  names through the resolver that forwards to it.
- Logs go to syslog.
- Resolver lists are downloaded at start and verified with the upstream
  minisign key.
- `require_dnssec`, `require_nolog` and `require_nofilter` are `true`. This
  leaves about 470 servers with the upstream lists at the time of testing.
  These flags select resolvers by what they advertise. They do not validate
  answers in the proxy.
- `bootstrap_resolvers` are plain DNS (UDP port 53). They are only used to find
  the addresses of the resolver list hosts. The lists themselves are verified
  by signature. Replace them with resolvers you trust.
- DoH certificates are verified against the system store. The package depends on
  `ca-certificates`, which installs `.crt` files in `/etc/ssl/certs`. Go reads
  that directory, but this was not tested on a device.
- `user_name` is not set, because it is not known whether the firmware has an
  unprivileged user to switch to. The listen port is above 1024, so the daemon
  can be started as such a user by the integration.

Anonymized DNSCrypt and ODoH send queries through a relay. Relays are chosen by
`routes` in the `[anonymized_dns]` section, which is commented out because the
choice of relays is a policy decision. Without routes, ODoH servers are not
used and the daemon logs `No relay defined for [...]`.

Useful options for process management: `-pidfile <file>`, `-check`
(validate the configuration and exit), `-version`.

## Integration

Nothing in the SDK starts the daemon, adds it to a component list, or exposes it
in the web interface or CLI. For DoT and DoH this is done by the closed-source
NDM, which writes a stubby or https-dns-proxy configuration pointing to a
loopback address. DNSCrypt needs the equivalent NDM change, which can only be
made by Keenetic.

## Verification

Done on Ubuntu (WSL2, x86_64) with upstream 2.1.21 and Go 1.27.4:

- Cross-compiled `linux/arm64`, `linux/mipsle` and `linux/mips` with the
  flags used by `Makefile`.
- `dnscrypt-proxy -check` accepts `files/dnscrypt-proxy.toml`. All four
  resolver lists load and pass signature verification.
- A `linux/amd64` build of the same source with the same configuration answered
  A queries on `127.0.0.1:5359`, using DNSCrypt and DoH servers.
- `make prepare-tmpinfo` in the SDK parses the package.

Not done:

- A full SDK build (`make package/net/dnscrypt-proxy/compile`).
- Running on a Keenetic device.
- Anonymized DNSCrypt and ODoH queries (no routes are configured by default).
