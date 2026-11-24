'use strict';

// Logic of the DNSCrypt settings page template: DNS stamp handling, validation
// and generation of dnscrypt-proxy.toml. It has no DOM access, so it runs in a
// browser and in Node (see tests/core.test.js).

(function (root, factory) {
  if (typeof module === 'object' && module.exports) {
    module.exports = factory();
  } else {
    root.DnsCryptCore = factory();
  }
})(typeof self !== 'undefined' ? self : this, function () {
  var B64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';
  var MINISIGN_KEY = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3';
  var LIST_BASE = [
    'https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/',
    'https://download.dnscrypt.info/resolvers-list/v3/',
    'https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/'
  ];
  // The DoT and DoH pages of KeeneticOS allow at most 8 servers. The same limit
  // is used here so that both pages behave alike. The daemon has no such limit.
  var MAX_SERVERS = 8;

  // ---- base64url ----------------------------------------------------------

  function b64urlEncode(bytes) {
    var out = '';
    for (var i = 0; i < bytes.length; i += 3) {
      var a = bytes[i];
      var b = i + 1 < bytes.length ? bytes[i + 1] : 0;
      var c = i + 2 < bytes.length ? bytes[i + 2] : 0;
      out += B64[a >> 2] + B64[((a & 3) << 4) | (b >> 4)];
      if (i + 1 < bytes.length) out += B64[((b & 15) << 2) | (c >> 6)];
      if (i + 2 < bytes.length) out += B64[c & 63];
    }
    return out;
  }

  function b64urlDecode(s) {
    s = s.replace(/=+$/, '');
    if (!/^[A-Za-z0-9_-]*$/.test(s) || s.length % 4 === 1) {
      throw new Error('the stamp is not valid base64url');
    }
    var out = [];
    var buf = 0;
    var bits = 0;
    for (var i = 0; i < s.length; i++) {
      buf = (buf << 6) | B64.indexOf(s[i]);
      bits += 6;
      if (bits >= 8) {
        bits -= 8;
        out.push((buf >> bits) & 255);
        buf &= (1 << bits) - 1;
      }
    }
    return Uint8Array.from(out);
  }

  // ---- DNS stamps (https://dnscrypt.info/stamps-specifications) -----------
  // Fully handled: 0x01 DNSCrypt server, 0x02 DoH server, 0x81 DNSCrypt relay.
  // Other types are recognised and kept unchanged, but their fields are not
  // interpreted.

  var PROTO_NAMES = {
    0x01: 'DNSCrypt',
    0x02: 'DoH',
    0x03: 'DoT',
    0x04: 'DoQ',
    0x05: 'ODoH target',
    0x81: 'DNSCrypt relay',
    0x85: 'ODoH relay'
  };

  function Reader(bytes) {
    this.b = bytes;
    this.i = 0;
  }
  Reader.prototype.u8 = function () {
    if (this.i >= this.b.length) throw new Error('the stamp is truncated');
    return this.b[this.i++];
  };
  Reader.prototype.take = function (n) {
    if (this.i + n > this.b.length) throw new Error('the stamp is truncated');
    var s = this.b.slice(this.i, this.i + n);
    this.i += n;
    return s;
  };
  Reader.prototype.lp = function () {
    return this.take(this.u8());
  };
  // A set of length-prefixed values: the high bit of a length byte means that
  // another value follows.
  Reader.prototype.vlp = function () {
    var set = [];
    for (;;) {
      var n = this.u8();
      set.push(this.take(n & 0x7f));
      if (!(n & 0x80)) break;
    }
    return set;
  };

  function text(bytes) {
    try {
      return new TextDecoder('utf-8', { fatal: true }).decode(bytes);
    } catch (e) {
      throw new Error('the stamp contains text that is not valid UTF-8');
    }
  }
  function bytesOf(str) {
    return new TextEncoder().encode(str);
  }
  function lpBytes(bytes) {
    if (bytes.length > 255) throw new Error('a stamp field is longer than 255 bytes');
    var out = new Uint8Array(bytes.length + 1);
    out[0] = bytes.length;
    out.set(bytes, 1);
    return out;
  }
  function vlpBytes(set) {
    if (set.length === 0) return Uint8Array.of(0);
    var parts = set.map(function (v, idx) {
      if (v.length > 127) throw new Error('a stamp hash is longer than 127 bytes');
      var out = new Uint8Array(v.length + 1);
      out[0] = v.length | (idx < set.length - 1 ? 0x80 : 0);
      out.set(v, 1);
      return out;
    });
    return concat(parts);
  }
  function concat(parts) {
    var n = 0;
    parts.forEach(function (p) {
      n += p.length;
    });
    var out = new Uint8Array(n);
    var o = 0;
    parts.forEach(function (p) {
      out.set(p, o);
      o += p.length;
    });
    return out;
  }

  // ---- the rules of the daemon's own stamp parser ---------------------------
  // A custom stamp that this page accepts has to be accepted by the daemon too,
  // otherwise the daemon stops at start with "Invalid stamp". The checks below follow
  // go-dnsstamps as it is vendored in dnscrypt-proxy 2.1.21. tests/stamp-parity.js
  // compares both parsers on damaged stamps. Where they differ, this page is the
  // stricter one.

  function isIPv4(s) {
    var m = /^(0|[1-9]\d{0,2})\.(0|[1-9]\d{0,2})\.(0|[1-9]\d{0,2})\.(0|[1-9]\d{0,2})$/.exec(s);
    return !!m && m.slice(1).every(function (o) { return +o <= 255; });
  }

  function isIPv6(s) {
    if (s.indexOf('%') !== -1 || /:::/.test(s)) return false;
    var dbl = s.indexOf('::');
    if (dbl !== s.lastIndexOf('::')) return false;
    var head = dbl === -1 ? s : s.slice(0, dbl);
    var tail = dbl === -1 ? '' : s.slice(dbl + 2);
    var groups = (head === '' ? [] : head.split(':')).concat(tail === '' ? [] : tail.split(':'));
    var count = 0;
    for (var i = 0; i < groups.length; i++) {
      var g = groups[i];
      if (i === groups.length - 1 && g.indexOf('.') !== -1) {
        if (!isIPv4(g)) return false;
        count += 2;
      } else if (/^[0-9A-Fa-f]{1,4}$/.test(g)) {
        count += 1;
      } else {
        return false;
      }
    }
    return dbl === -1 ? count === 8 : count < 8;
  }

  function isIp(s) {
    return isIPv4(s) || isIPv6(s);
  }

  function isPortText(p) {
    return /^\d+$/.test(p) && +p >= 1 && +p <= 65535;
  }

  // Address of a DNSCrypt server or relay: an IP address with an optional port.
  function checkServerAddr(addr) {
    var col = addr.lastIndexOf(':');
    if (col < addr.lastIndexOf(']')) col = -1;
    var full = addr;
    if (col < 0) {
      col = addr.length;
      full = addr + ':443';
    }
    if (col >= full.length - 1) throw new Error('the server address has an empty port');
    if (!isPortText(full.slice(col + 1))) throw new Error('the port in the stamp is not from 1 to 65535');
    var ip = full.slice(0, col).replace(/^\[+/, '').replace(/\]+$/, '');
    if (!isIp(ip)) throw new Error('the server address in the stamp is not an IP address');
  }

  // Host name of a DoH or ODoH stamp, with an optional port.
  function checkHostName(host) {
    var i = host.lastIndexOf(':');
    var port = '';
    if (i !== -1 && host.lastIndexOf(']') < i) {
      port = host.slice(i + 1);
    }
    if (port === '') {
      if (/:$/.test(host)) throw new Error('the host name in the stamp has an empty port');
      return;
    }
    if (!isPortText(port)) throw new Error('the port in the stamp is not from 1 to 65535');
  }

  // The IP address of a DoH stamp has no port. IPv6 addresses are in brackets.
  function checkDohAddr(addr) {
    if (addr.length === 0) return;
    var ip = addr;
    if (ip.charAt(0) === '[' && ip.charAt(ip.length - 1) === ']') ip = ip.slice(1, -1);
    else if (ip.indexOf(':') !== -1) throw new Error('the server IP address in the stamp must not have a port');
    if (!isIp(ip)) throw new Error('the server address in the stamp is not an IP address');
  }

  // Reads the optional bootstrap IP addresses after the path, and requires the end.
  function readTail(r, bytes) {
    var tail = new Uint8Array(0);
    if (r.i < bytes.length) {
      var start = r.i;
      r.vlp();
      tail = bytes.slice(start, r.i);
    }
    if (r.i !== bytes.length) throw new Error('the stamp has unexpected trailing data');
    return tail;
  }

  function readHashes(r) {
    var hashes = r.vlp();
    hashes.forEach(function (h) {
      if (h.length !== 0 && h.length !== 32) throw new Error('a certificate hash in the stamp is not 32 bytes long');
    });
    return hashes;
  }

  function minLength(bytes, n) {
    if (bytes.length < n) throw new Error('the stamp is too short');
  }

  function decodeStamp(stamp) {
    if (typeof stamp !== 'string' || stamp.indexOf('sdns://') !== 0) {
      throw new Error('a DNS stamp starts with sdns://');
    }
    var body = stamp.slice(7);
    var bytes = b64urlDecode(body);
    if (b64urlEncode(bytes) !== body) throw new Error('the stamp is not valid base64url');
    if (bytes.length === 0) throw new Error('the stamp is empty');
    var r = new Reader(bytes);
    var proto = r.u8();
    var st = { proto: proto, protoName: PROTO_NAMES[proto] || 'unknown (0x' + proto.toString(16) + ')' };
    if (proto === 0x01) {
      minLength(bytes, 66);
      st.kind = 'dnscrypt';
      st.props = r.take(8);
      st.addr = text(r.lp());
      st.publicKey = r.lp();
      st.provider = text(r.lp());
      if (r.i !== bytes.length) throw new Error('the stamp has unexpected trailing data');
      checkServerAddr(st.addr);
      if (st.publicKey.length !== 32) throw new Error('the public key in the stamp is not 32 bytes long');
    } else if (proto === 0x02 || proto === 0x85) {
      minLength(bytes, proto === 0x02 ? 15 : 13);
      st.kind = proto === 0x02 ? 'doh' : 'odohrelay';
      st.props = r.take(8);
      st.addr = text(r.lp());
      st.hashes = readHashes(r);
      st.host = text(r.lp());
      st.path = text(r.lp());
      st.tail = readTail(r, bytes);
      checkDohAddr(st.addr);
      checkHostName(st.host);
    } else if (proto === 0x05) {
      minLength(bytes, 12);
      st.kind = 'odohtarget';
      st.props = r.take(8);
      st.host = text(r.lp());
      st.path = text(r.lp());
      if (r.i !== bytes.length) throw new Error('the stamp has unexpected trailing data');
      checkHostName(st.host);
    } else if (proto === 0x81) {
      minLength(bytes, 9);
      st.kind = 'relay';
      st.addr = text(r.lp());
      if (r.i !== bytes.length) throw new Error('the stamp has unexpected trailing data');
      checkServerAddr(st.addr);
    } else {
      st.kind = 'other';
      st.raw = bytes;
    }
    return st;
  }

  function encodeStamp(st) {
    var body;
    if (st.kind === 'dnscrypt') {
      body = concat([Uint8Array.of(0x01), st.props, lpBytes(bytesOf(st.addr)), lpBytes(st.publicKey), lpBytes(bytesOf(st.provider))]);
    } else if (st.kind === 'doh' || st.kind === 'odohrelay') {
      body = concat([
        Uint8Array.of(st.kind === 'doh' ? 0x02 : 0x85),
        st.props,
        lpBytes(bytesOf(st.addr)),
        vlpBytes(st.hashes),
        lpBytes(bytesOf(st.host)),
        lpBytes(bytesOf(st.path)),
        st.tail || new Uint8Array(0)
      ]);
    } else if (st.kind === 'odohtarget') {
      body = concat([Uint8Array.of(0x05), st.props, lpBytes(bytesOf(st.host)), lpBytes(bytesOf(st.path))]);
    } else if (st.kind === 'relay') {
      body = concat([Uint8Array.of(0x81), lpBytes(bytesOf(st.addr))]);
    } else if (st.kind === 'other') {
      body = st.raw;
    } else {
      throw new Error('cannot encode this stamp type');
    }
    return 'sdns://' + b64urlEncode(body);
  }
  function splitAddr(addr) {
    if (addr === '') return { host: '', port: null };
    var m = /^\[([^\]]+)\](?::(\d{1,5}))?$/.exec(addr);
    if (m) return { host: '[' + m[1] + ']', port: m[2] ? +m[2] : null };
    m = /^([^:]+)(?::(\d{1,5}))?$/.exec(addr);
    if (m) return { host: m[1], port: m[2] ? +m[2] : null };
    throw new Error('unrecognised server address: ' + addr);
  }

  function hostParts(host) {
    var i = host.lastIndexOf(':');
    if (i !== -1 && host.lastIndexOf(']') < i && /^\d+$/.test(host.slice(i + 1))) {
      return { host: host.slice(0, i), port: +host.slice(i + 1) };
    }
    return { host: host, port: null };
  }

  // What a user needs to see about a stamp.
  function describeStamp(stamp) {
    var st = typeof stamp === 'string' ? decodeStamp(stamp) : stamp;
    var d = { protoName: st.protoName, kind: st.kind, address: '', port: null, name: '', path: '' };
    if (st.kind === 'dnscrypt' || st.kind === 'relay') {
      var a = splitAddr(st.addr);
      d.address = a.host;
      d.port = a.port || 443;
    }
    if (st.kind === 'dnscrypt') d.name = st.provider;
    if (st.kind === 'doh' || st.kind === 'odohrelay' || st.kind === 'odohtarget') {
      var hp = hostParts(st.host);
      d.address = st.addr || '';
      d.name = hp.host;
      d.port = hp.port || 443;
      d.path = st.path;
    }
    return d;
  }

  function validPort(port) {
    return typeof port === 'number' && isFinite(port) && Math.floor(port) === port && port >= 1 && port <= 65535;
  }

  // Returns a stamp that uses another port. The server has to listen there:
  // the port is chosen by the server operator and is not negotiated.
  function withPort(stamp, port) {
    if (!validPort(port)) throw new Error('the port must be a number from 1 to 65535');
    var st = decodeStamp(stamp);
    if (st.kind !== 'dnscrypt' && st.kind !== 'relay') {
      throw new Error('the port can be changed for DNSCrypt servers and relays only');
    }
    var a = splitAddr(st.addr);
    if (a.host === '') throw new Error('the stamp has no server address');
    st.addr = a.host + ':' + port;
    return encodeStamp(st);
  }

  // "IPv4:port" or "[IPv6]:port".
  function validIpPort(s) {
    var m = /^(?:([^\[\]:]+)|\[([^\]]+)\]):(\d+)$/.exec(s || '');
    if (!m || !isPortText(m[3])) return false;
    return m[1] !== undefined ? isIPv4(m[1]) : isIPv6(m[2]);
  }

  // Builds a DoH stamp from an address such as https://dns.example/dns-query.
  // flags only describe the server to the user (DNSSEC, no logs, no filter).
  function buildDohStamp(opts) {
    var m = /^https:\/\/([^\/\s?#]+)(\/[^\s?#]*)?$/i.exec((opts.url || '').trim());
    if (!m) throw new Error('enter an address that starts with https:// and has no query string');
    var host = m[1];
    if (!/^([A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*|\[[0-9A-Fa-f:]+\])(:\d{1,5})?$/.test(host)) {
      throw new Error('the host name is not valid');
    }
    var hp = /:(\d{1,5})$/.exec(host);
    if (hp && !validPort(+hp[1])) throw new Error('the port must be a number from 1 to 65535');
    var path = m[2] || '/dns-query';
    if (!/^\/[A-Za-z0-9._~!$&'()*+,;=:@%\/-]*$/.test(path)) throw new Error('the path contains unsupported characters');
    var addr = (opts.ip || '').trim();
    if (addr !== '') {
      var v6 = /^\[(.*)\]$/.exec(addr);
      if (!(v6 ? isIPv6(v6[1]) : isIPv4(addr))) {
        throw new Error('the server IP address is not valid. Enter it without a port, and IPv6 addresses in brackets');
      }
    }
    var flags = (opts.dnssec ? 1 : 0) | (opts.nolog ? 2 : 0) | (opts.nofilter ? 4 : 0);
    var built = encodeStamp({
      kind: 'doh',
      props: Uint8Array.of(flags, 0, 0, 0, 0, 0, 0, 0),
      addr: addr,
      hashes: [],
      host: host,
      path: path
    });
    decodeStamp(built);     // the page never hands out a stamp that the daemon would refuse
    return built;
  }

  // ---- resolver lists -----------------------------------------------------
  // Input is the output of
  //   dnscrypt-proxy -list-all -include-relays -json
  // The protocol label differs per kind, e.g. "DoH", "DNSCrypt relay", "oDoH target".

  function classify(label) {
    var l = String(label || '').toLowerCase();
    var relay = /relay\s*$/.test(l);
    if (l.indexOf('odoh') !== -1) return { kind: 'odoh', relay: relay };
    if (l.indexOf('dnscrypt') !== -1) return { kind: 'dnscrypt', relay: relay };
    if (l.indexOf('doh') !== -1) return { kind: 'doh', relay: relay };
    return { kind: 'other', relay: relay };
  }

  function cleanText(s, max) {
    return String(s || '').replace(/[\u0000-\u001f\u007f]/g, ' ').slice(0, max);
  }

  function normalizeList(json) {
    if (!Array.isArray(json)) throw new Error('the list must be a JSON array');
    var servers = [];
    var relays = [];
    json.forEach(function (o) {
      if (!o || typeof o.name !== 'string') return;
      var c = classify(o.proto);
      var item = {
        name: o.name,
        kind: c.kind,
        ports: Array.isArray(o.ports) ? o.ports.filter(validPort) : [],
        ipv6: !!o.ipv6,
        dnssec: !!o.dnssec,
        nolog: !!o.nolog,
        nofilter: !!o.nofilter,
        description: cleanText(o.description, 300)
      };
      if (c.kind === 'other') return;
      (c.relay ? relays : servers).push(item);
    });
    return { servers: servers, relays: relays };
  }

  function filterServers(servers, f) {
    var q = (f.text || '').trim().toLowerCase();
    return servers.filter(function (s) {
      if (!f.kinds[s.kind]) return false;
      if (f.port443 && s.ports.indexOf(443) === -1) return false;
      if (f.dnssec && !s.dnssec) return false;
      if (f.nolog && !s.nolog) return false;
      if (f.nofilter && !s.nofilter) return false;
      if (!f.ipv6 && s.ipv6) return false;
      if (q && s.name.toLowerCase().indexOf(q) === -1) return false;
      return true;
    });
  }

  // ---- validation ---------------------------------------------------------

  var NAME_RE = /^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$/;
  var CUSTOM_NAME_RE = /^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$/;

  function validListen(addr) {
    return validIpPort(addr);
  }

  function isLoopback(addr) {
    return /^127\./.test(addr) || /^\[::1\]/.test(addr);
  }

  function validate(state) {
    var out = [];
    function err(field, msg) { out.push({ level: 'error', field: field, msg: msg }); }
    function warn(field, msg) { out.push({ level: 'warning', field: field, msg: msg }); }

    if (!validListen(state.listen)) {
      err('listen', 'The listen address must look like 127.0.0.1:5359 or [::1]:5359.');
    } else if (!isLoopback(state.listen)) {
      warn('listen', 'This address is not a loopback address. Devices on the network could use the proxy directly.');
    }
    var mark = state.socketMark || 0;
    if (!(Math.floor(mark) === mark && mark >= 0 && mark <= 0x7fffffff)) {
      err('socketMark', 'The socket mark must be a whole number from 0 to 2147483647.');
    }
    (state.bootstrap || []).forEach(function (b) {
      if (!validIpPort(b)) {
        err('bootstrap', 'Bootstrap resolver "' + b + '" must be an IP address with a port, for example 9.9.9.9:53.');
      }
    });
    if (!state.servers.length) err('servers', 'Add at least one server.');
    if (state.servers.length > MAX_SERVERS) {
      err('servers', 'At most ' + MAX_SERVERS + ' servers can be used, as on the DoT and DoH pages.');
    }

    var seen = {};
    state.servers.forEach(function (s) {
      var f = 'server:' + s.name;
      if (!NAME_RE.test(s.name || '')) err(f, 'The server name "' + s.name + '" has unsupported characters.');
      if (seen[s.name]) err(f, 'The server name "' + s.name + '" is used twice.');
      seen[s.name] = true;

      var kind = s.kind;
      if (s.source === 'custom') {
        if (!CUSTOM_NAME_RE.test(s.name || '')) {
          err(f, 'A custom server name may contain letters, digits, "_" and "-" only.');
        }
        try {
          var st = decodeStamp(s.stamp);
          if (st.kind === 'relay' || st.kind === 'odohrelay') err(f, 'This is a relay stamp. Add it as a relay of a server.');
          else if (st.proto === 0x03) err(f, 'DNS-over-TLS stamps are not supported by this proxy. Use the DNS-over-TLS page.');
          else if (st.kind === 'other') err(f, 'This stamp type is not supported. Use a DNSCrypt, DNS-over-HTTPS or Oblivious DoH stamp.');
          if (st.kind === 'odohtarget') kind = 'odoh';
          else if (st.kind === 'dnscrypt' || st.kind === 'doh') kind = st.kind;
        } catch (e) {
          err(f, 'The stamp is not valid: ' + e.message + '.');
        }
      } else if (s.flags) {
        var missing = [];
        if (state.require.dnssec && !s.flags.dnssec) missing.push('DNSSEC');
        if (state.require.nolog && !s.flags.nolog) missing.push('no logging');
        if (state.require.nofilter && !s.flags.nofilter) missing.push('no filtering');
        if (missing.length) {
          warn(f, '"' + s.name + '" does not advertise ' + missing.join(', ') + '. Servers that are chosen by name are used even when they do not meet the required properties.');
        }
      }

      if (kind === 'dnscrypt' && !state.protocols.dnscrypt) err(f, '"' + s.name + '" needs DNSCrypt to be enabled.');
      if (kind === 'doh' && !state.protocols.doh) err(f, '"' + s.name + '" needs DNS-over-HTTPS to be enabled.');
      if (kind === 'odoh') {
        if (!state.protocols.odoh) err(f, '"' + s.name + '" needs Oblivious DoH to be enabled.');
        if (!s.relays) err(f, 'Oblivious DoH works only through a relay. Choose a relay for "' + s.name + '".');
      }

      if (Array.isArray(s.relays)) {
        if (!s.relays.length) err(f, 'Choose at least one relay for "' + s.name + '" or select automatic.');
        s.relays.forEach(function (r) {
          if (/^sdns:\/\//.test(r)) {
            try {
              var rs = decodeStamp(r);
              if (rs.kind !== 'relay' && rs.kind !== 'odohrelay') err(f, 'A relay stamp must be a relay stamp.');
            } catch (e) {
              err(f, 'A relay stamp is not valid: ' + e.message + '.');
            }
          } else if (!NAME_RE.test(r)) {
            err(f, 'The relay name "' + r + '" has unsupported characters.');
          }
        });
      }
      if (s.relays && !state.forceTcp && kind === 'dnscrypt') {
        warn(f, 'Anonymized DNSCrypt sends large UDP packets. If they are fragmented or dropped on the way, the server cannot be reached. Turn on "Use TCP" if it fails.');
      }
    });

    if (state.http3 && state.forceTcp) {
      warn('http3', 'HTTP/3 uses UDP. It is not related to the TCP setting for DNSCrypt.');
    }
    return out;
  }

  // ---- dnscrypt-proxy.toml ------------------------------------------------

  function q(s) {
    if (/['\r\n]/.test(s)) throw new Error('a value contains a character that is not allowed in the configuration');
    return "'" + s + "'";
  }
  function list(items) {
    return '[' + items.map(q).join(', ') + ']';
  }

  function sourceBlock(name, file) {
    var urls = LIST_BASE.map(function (b) {
      return '    ' + q(b + file);
    }).join(',\n');
    return [
      '  [sources.' + name + ']',
      '  urls = [',
      urls,
      '  ]',
      "  cache_file = '/tmp/dnscrypt-proxy/" + file + "'",
      '  minisign_key = ' + q(MINISIGN_KEY),
      '  refresh_delay = 73',
      "  prefix = ''",
      ''
    ].join('\n');
  }

  function generateToml(state) {
    var errors = validate(state).filter(function (p) { return p.level === 'error'; });
    if (errors.length) throw new Error(errors[0].msg);
    var servers = state.servers;
    var lines = [];
    var add = function (s) { lines.push(s); };

    var listServers = servers.filter(function (s) { return s.source === 'list'; });
    var needRelayList = false;
    var needOdohRelayList = false;
    var routes = [];
    servers.forEach(function (s) {
      if (!s.relays) return;
      var via = s.relays === 'auto' ? ['*'] : s.relays;
      routes.push("  { server_name=" + q(s.name) + ', via=' + list(via) + ' }');
      var odoh = s.kind === 'odoh';
      if (s.relays === 'auto') {
        if (odoh) needOdohRelayList = true;
        else needRelayList = true;
      } else {
        s.relays.forEach(function (r) {
          if (/^sdns:\/\//.test(r)) return;
          if (odoh) needOdohRelayList = true;
          else needRelayList = true;
        });
      }
    });
    var needPublic = listServers.some(function (s) { return s.kind === 'dnscrypt' || s.kind === 'doh'; });
    var needOdohServers = listServers.some(function (s) { return s.kind === 'odoh'; });

    add('# Generated by the DNSCrypt settings page template. Check it with:');
    add('#   dnscrypt-proxy -config <this file> -check');
    add('');
    add('listen_addresses = ' + list([state.listen]));
    add('max_clients = 250');
    add('');
    add('ipv4_servers = true');
    add('ipv6_servers = ' + (state.ipv6 ? 'true' : 'false'));
    add('dnscrypt_servers = ' + (state.protocols.dnscrypt ? 'true' : 'false'));
    add('doh_servers = ' + (state.protocols.doh ? 'true' : 'false'));
    add('odoh_servers = ' + (state.protocols.odoh ? 'true' : 'false'));
    add('');
    add('require_dnssec = ' + (state.require.dnssec ? 'true' : 'false'));
    add('require_nolog = ' + (state.require.nolog ? 'true' : 'false'));
    add('require_nofilter = ' + (state.require.nofilter ? 'true' : 'false'));
    add('server_names = ' + list(servers.map(function (s) { return s.name; })));
    add('');
    add('force_tcp = ' + (state.forceTcp ? 'true' : 'false'));
    add('http3 = ' + (state.http3 ? 'true' : 'false'));
    add('pqdnscrypt = ' + (state.pq ? 'true' : 'false'));
    if (state.socketMark) add('socket_mark = ' + state.socketMark);
    add('timeout = 5000');
    add('keepalive = 30');
    add('');
    add('use_syslog = true');
    add('bootstrap_resolvers = ' + list(state.bootstrap));
    add('ignore_system_dns = true');
    add('netprobe_timeout = 60');
    add('netprobe_address = ' + q(state.bootstrap[0] || '9.9.9.9:53'));
    add('');
    add('cache = true');
    add('cache_size = 4096');
    add('cache_min_ttl = 2400');
    add('cache_max_ttl = 86400');
    add('cache_neg_min_ttl = 60');
    add('cache_neg_max_ttl = 600');
    add('');
    add('[monitoring_ui]');
    add('enabled = false');
    add('');
    if (needPublic || needRelayList || needOdohServers || needOdohRelayList) {
      add('[sources]');
      add('');
      if (needPublic) add(sourceBlock('public-resolvers', 'public-resolvers.md'));
      if (needRelayList) add(sourceBlock('relays', 'relays.md'));
      if (needOdohServers) add(sourceBlock('odoh-servers', 'odoh-servers.md'));
      if (needOdohRelayList) add(sourceBlock('odoh-relays', 'odoh-relays.md'));
    }
    if (routes.length) {
      add('[anonymized_dns]');
      add('routes = [');
      add(routes.join(',\n'));
      add(']');
      add('skip_incompatible = true');
      add('');
    }
    var custom = servers.filter(function (s) { return s.source === 'custom'; });
    if (custom.length) {
      add('[static]');
      custom.forEach(function (s) {
        add('  [static.' + s.name + ']');
        add('  stamp = ' + q(s.stamp));
      });
      add('');
    }
    return lines.join('\n');
  }

  function defaultState() {
    return {
      listen: '127.0.0.1:5359',
      protocols: { dnscrypt: true, doh: true, odoh: false },
      ipv6: false,
      require: { dnssec: true, nolog: true, nofilter: true },
      forceTcp: false,
      http3: false,
      pq: true,
      socketMark: 0,
      bootstrap: ['9.9.9.9:53', '1.1.1.1:53'],
      servers: []
    };
  }

  return {
    MAX_SERVERS: MAX_SERVERS,
    b64urlEncode: b64urlEncode,
    b64urlDecode: b64urlDecode,
    decodeStamp: decodeStamp,
    encodeStamp: encodeStamp,
    describeStamp: describeStamp,
    withPort: withPort,
    buildDohStamp: buildDohStamp,
    normalizeList: normalizeList,
    filterServers: filterServers,
    validate: validate,
    generateToml: generateToml,
    defaultState: defaultState
  };
});
