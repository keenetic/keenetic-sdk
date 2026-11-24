'use strict';

// Run with:  node tests/core.test.js [--list <file.json>] [--write <dir>]
//   --list   output of "dnscrypt-proxy -list-all -include-relays -json". Every
//            stamp in it must survive decode and encode unchanged.
//   --write  writes the generated configurations to <dir> so that they can be
//            checked with "dnscrypt-proxy -check".

var assert = require('assert');
var fs = require('fs');
var path = require('path');
var core = require('../core.js');

var args = process.argv.slice(2);
function opt(name) {
  var i = args.indexOf(name);
  return i === -1 ? null : args[i + 1];
}

var passed = 0;
function test(name, fn) {
  try {
    fn();
    passed++;
    console.log('ok   ' + name);
  } catch (e) {
    console.log('FAIL ' + name + '\n     ' + (e && e.stack ? e.stack.split('\n').slice(0, 3).join('\n     ') : e));
    process.exitCode = 1;
  }
}

// Stamps built with an independent encoder (Python), using the documentation
// address range 192.0.2.0/24 and an all-zero key. They never reach a real server.
var DNSCRYPT = 'sdns://AQcAAAAAAAAADTE5Mi4wLjIuMTo0NDMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMi5kbnNjcnlwdC1jZXJ0LmV4YW1wbGUuY29t';
var RELAY = 'sdns://gQ0xOTIuMC4yLjI6NDQz';

function state(extra) {
  var s = core.defaultState();
  Object.keys(extra || {}).forEach(function (k) { s[k] = extra[k]; });
  return s;
}
function listServer(name, kind, flags, relays) {
  return { name: name, source: 'list', kind: kind, relays: relays || null, flags: flags || { dnssec: true, nolog: true, nofilter: true } };
}
function errors(s) {
  return core.validate(s).filter(function (p) { return p.level === 'error'; }).map(function (p) { return p.msg; });
}
function warnings(s) {
  return core.validate(s).filter(function (p) { return p.level === 'warning'; }).map(function (p) { return p.msg; });
}

test('base64url round trip for all lengths', function () {
  for (var n = 0; n < 40; n++) {
    var b = Uint8Array.from(Array.from({ length: n }, function (_, i) { return (i * 37 + n) & 255; }));
    var e = core.b64urlEncode(b);
    assert.ok(!/[=+/]/.test(e));
    assert.deepStrictEqual(Array.from(core.b64urlDecode(e)), Array.from(b));
  }
});

test('decode a DNSCrypt stamp made by another encoder', function () {
  var st = core.decodeStamp(DNSCRYPT);
  assert.strictEqual(st.kind, 'dnscrypt');
  assert.strictEqual(st.addr, '192.0.2.1:443');
  assert.strictEqual(st.provider, '2.dnscrypt-cert.example.com');
  assert.strictEqual(st.publicKey.length, 32);
  assert.strictEqual(st.props[0], 7);
});

test('decode a relay stamp made by another encoder', function () {
  var st = core.decodeStamp(RELAY);
  assert.strictEqual(st.kind, 'relay');
  assert.strictEqual(st.addr, '192.0.2.2:443');
});

test('encode(decode(x)) returns the same stamp', function () {
  [DNSCRYPT, RELAY].forEach(function (s) {
    assert.strictEqual(core.encodeStamp(core.decodeStamp(s)), s);
  });
});

test('change the port of a DNSCrypt stamp and of a relay stamp', function () {
  assert.strictEqual(core.describeStamp(core.withPort(DNSCRYPT, 8443)).port, 8443);
  assert.strictEqual(core.describeStamp(core.withPort(RELAY, 5443)).port, 5443);
  assert.strictEqual(core.describeStamp(core.withPort(DNSCRYPT, 8443)).address, '192.0.2.1');
  assert.strictEqual(core.describeStamp(DNSCRYPT).port, 443);
});

test('reject a bad port and a stamp type whose port cannot be changed', function () {
  [0, 65536, 1.5, NaN, '443'].forEach(function (p) {
    assert.throws(function () { core.withPort(DNSCRYPT, p); });
  });
  var doh = core.buildDohStamp({ url: 'https://dns.example/dns-query', ip: '192.0.2.1' });
  assert.throws(function () { core.withPort(doh, 8443); }, /DNSCrypt servers and relays only/);
});

test('reject malformed stamps', function () {
  ['', 'abc', 'sdns://', 'sdns://!!!', 'sdns://AQ', DNSCRYPT.slice(0, -6), DNSCRYPT + 'AAAA'].forEach(function (s) {
    assert.throws(function () { core.decodeStamp(s); }, undefined, s);
  });
});

test('text that is not UTF-8 gives a readable error, not a TypeError', function () {
  var bytes = Array.from(core.b64urlDecode(DNSCRYPT.slice(7)));
  bytes[bytes.length - 1] = 0xff;                 // the last byte of the provider name
  var stamp = 'sdns://' + core.b64urlEncode(Uint8Array.from(bytes));
  assert.throws(function () { core.decodeStamp(stamp); }, function (e) {
    return e.constructor === Error && /not valid UTF-8/.test(e.message);
  });
  assert.strictEqual(core.decodeStamp(DNSCRYPT).kind, 'dnscrypt');     // the undamaged stamp is fine
});
function craft(obj) { return core.encodeStamp(obj); }
var ZERO8 = new Uint8Array(8);
var KEY = new Uint8Array(32);
var HASH = new Uint8Array(32);

test('rules of the daemon: DNSCrypt stamps', function () {
  function d(over) { return craft(Object.assign({ kind: 'dnscrypt', props: ZERO8, addr: '192.0.2.1:443', publicKey: KEY, provider: '2.dnscrypt-cert.example.com' }, over)); }
  assert.strictEqual(core.decodeStamp(d({})).addr, '192.0.2.1:443');
  assert.strictEqual(core.decodeStamp(d({ addr: '[2001:db8::1]:8443' })).addr, '[2001:db8::1]:8443');
  assert.strictEqual(core.decodeStamp(d({ addr: '192.0.2.1' })).addr, '192.0.2.1');          // the port is optional
  [
    { addr: '' }, { addr: 'dns.example:443' }, { addr: '192.0.2.1:' }, { addr: '192.0.2.1:0' }, { addr: '192.0.2.1:65536' },
    { addr: '192.0.2.1:abc' }, { addr: '999.0.2.1:443' }, { addr: '01.2.3.4:443' }, { addr: '2001:db8::1' },
    { addr: '[2001:db8::1' }, { addr: '[2001:db8::g]:443' }, { addr: '[1:2:3:4:5:6:7:8:9]:443' },
    { publicKey: new Uint8Array(31) }, { publicKey: new Uint8Array(33) }, { publicKey: new Uint8Array(0) }
  ].forEach(function (over) {
    assert.throws(function () { core.decodeStamp(d(over)); }, Error, JSON.stringify(over, function (k, v) { return v instanceof Uint8Array ? 'bytes' + v.length : v; }));
  });
  assert.throws(function () { core.decodeStamp(d({ addr: '1.2.3.4:443', provider: '' })); }, /too short/);   // shorter than 66 bytes
});

test('rules of the daemon: DoH stamps', function () {
  function d(over) { return craft(Object.assign({ kind: 'doh', props: ZERO8, addr: '192.0.2.1', hashes: [], host: 'dns.example', path: '/dns-query' }, over)); }
  assert.strictEqual(core.decodeStamp(d({})).host, 'dns.example');
  assert.strictEqual(core.decodeStamp(d({ addr: '' })).addr, '');
  assert.strictEqual(core.decodeStamp(d({ addr: '[2001:db8::1]' })).addr, '[2001:db8::1]');
  assert.strictEqual(core.decodeStamp(d({ host: 'dns.example:8443' })).host, 'dns.example:8443');
  assert.strictEqual(core.decodeStamp(d({ hashes: [HASH, HASH] })).hashes.length, 2);
  // optional bootstrap addresses after the path
  var withTail = d({ tail: Uint8Array.of(7, 0x31, 0x2e, 0x32, 0x2e, 0x33, 0x2e, 0x34) });
  assert.strictEqual(core.encodeStamp(core.decodeStamp(withTail)), withTail);
  [
    { addr: '192.0.2.1:443' }, { addr: '[2001:db8::1]:443' }, { addr: 'dns.example' }, { addr: '999.0.2.1' },
    { hashes: [new Uint8Array(31)] }, { hashes: [HASH, new Uint8Array(33)] },
    { host: 'dns.example:' }, { host: 'dns.example:0' }, { host: 'dns.example:99999' },
    { tail: Uint8Array.of(9, 1) }, { tail: Uint8Array.of(0x81, 0) }, { tail: Uint8Array.of(0, 0) }
  ].forEach(function (over) {
    assert.throws(function () { core.decodeStamp(d(over)); }, Error, JSON.stringify(over, function (k, v) { return v instanceof Uint8Array ? 'bytes' + v.length : v; }));
  });
});

test('rules of the daemon: relays and Oblivious DoH', function () {
  assert.strictEqual(core.decodeStamp(craft({ kind: 'relay', addr: '192.0.2.2:443' })).kind, 'relay');
  assert.throws(function () { core.decodeStamp(craft({ kind: 'relay', addr: '192.0.2.2:0' })); });
  assert.throws(function () { core.decodeStamp(craft({ kind: 'relay', addr: 'a.b' })); });
  var target = craft({ kind: 'odohtarget', props: ZERO8, host: 'odoh.example', path: '/dns-query' });
  assert.strictEqual(core.decodeStamp(target).kind, 'odohtarget');
  assert.strictEqual(core.describeStamp(target).name, 'odoh.example');
  assert.throws(function () { core.decodeStamp(craft({ kind: 'odohtarget', props: ZERO8, host: 'odoh.example:0', path: '/' })); });
  var relay = craft({ kind: 'odohrelay', props: ZERO8, addr: '', hashes: [], host: 'relay.example', path: '/proxy' });
  assert.strictEqual(core.decodeStamp(relay).kind, 'odohrelay');
  assert.strictEqual(core.encodeStamp(core.decodeStamp(relay)), relay);
});

test('rules of the daemon: base64 has to be exact', function () {
  var body = DNSCRYPT.slice(7);
  assert.throws(function () { core.decodeStamp(DNSCRYPT + '='); }, Error);                   // padding
  assert.throws(function () { core.decodeStamp('sdns://' + body + 'A'); }, Error);   // extra character
  assert.throws(function () { core.decodeStamp('sdns://' + body + 'AA'); }, Error);  // extra byte
  assert.throws(function () { core.decodeStamp(' ' + DNSCRYPT); }, Error);
  assert.throws(function () { core.decodeStamp(DNSCRYPT + ' '); }, Error);
});

test('the page never builds a stamp that its own parser refuses', function () {
  ['https://dns.example/dns-query', 'https://dns.example:8443/x', 'https://[2001:db8::1]/x'].forEach(function (u) {
    ['', '192.0.2.1', '[2001:db8::1]'].forEach(function (ip) {
      core.decodeStamp(core.buildDohStamp({ url: u, ip: ip, dnssec: true }));
    });
  });
});
test('build a DoH stamp from an address', function () {
  var s = core.buildDohStamp({ url: 'https://dns.example/abc123', ip: '192.0.2.1', dnssec: true, nolog: true });
  var st = core.decodeStamp(s);
  assert.strictEqual(st.kind, 'doh');
  assert.strictEqual(st.host, 'dns.example');
  assert.strictEqual(st.path, '/abc123');
  assert.strictEqual(st.addr, '192.0.2.1');
  assert.strictEqual(st.props[0], 3);
  assert.strictEqual(core.encodeStamp(st), s);
  assert.strictEqual(core.decodeStamp(core.buildDohStamp({ url: 'https://dns.example' })).path, '/dns-query');
  assert.strictEqual(core.decodeStamp(core.buildDohStamp({ url: 'https://dns.example:8443/x' })).host, 'dns.example:8443');
  assert.strictEqual(core.decodeStamp(core.buildDohStamp({ url: 'https://dns.example/x', ip: '[2001:db8::1]' })).addr, '[2001:db8::1]');
});

test('reject bad DoH addresses', function () {
  [
    'http://dns.example/dns-query', 'https://', 'https://dns.example/x?a=1', 'https://dns.example/x#f',
    'https://bad host/x', 'https://dns.example/x"y', 'https://dns.example:99999/x', 'ftp://dns.example/x', ''
  ].forEach(function (u) {
    assert.throws(function () { core.buildDohStamp({ url: u }); }, undefined, u);
  });
  // An apostrophe is a valid URL character. The stamp is base64url, so it cannot reach the TOML file.
  assert.ok(core.buildDohStamp({ url: "https://dns.example/x'y" }).indexOf("'") === -1);
  ['999.1.1.1', '1.2.3', 'abc', '192.0.2.1:70000', '192.0.2.1:443', '[2001:db8::1]:443', '2001:db8::1', '01.2.3.4', '[1.2.3.4]'].forEach(function (ip) {
    assert.throws(function () { core.buildDohStamp({ url: 'https://dns.example/x', ip: ip }); }, undefined, ip);
  });
});

var sample = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'sample-resolvers.json'), 'utf8'));

test('normalize the sample list', function () {
  var l = core.normalizeList(sample);
  assert.strictEqual(l.servers.length, 6);
  assert.strictEqual(l.relays.length, 3);
  assert.deepStrictEqual(l.servers.map(function (s) { return s.kind; }).sort(), ['dnscrypt', 'dnscrypt', 'dnscrypt', 'doh', 'doh', 'odoh']);
  assert.throws(function () { core.normalizeList({}); });
});

test('filters: protocol, port 443, properties, text, IPv6', function () {
  var l = core.normalizeList(sample);
  var all = { kinds: { dnscrypt: true, doh: true, odoh: true }, ipv6: true };
  assert.strictEqual(core.filterServers(l.servers, all).length, 6);
  assert.strictEqual(core.filterServers(l.servers, { kinds: { dnscrypt: true }, ipv6: true }).length, 3);
  assert.strictEqual(core.filterServers(l.servers, { kinds: all.kinds, ipv6: true, port443: true }).length, 5);
  assert.strictEqual(core.filterServers(l.servers, { kinds: all.kinds, ipv6: true, nofilter: true }).length, 5);
  assert.strictEqual(core.filterServers(l.servers, { kinds: all.kinds, ipv6: true, dnssec: true, nolog: true }).length, 5);
  assert.strictEqual(core.filterServers(l.servers, { kinds: all.kinds, ipv6: false }).length, 5);
  assert.strictEqual(core.filterServers(l.servers, { kinds: all.kinds, ipv6: true, text: 'FILTERED' }).length, 1);
});

test('descriptions from a list are cleaned', function () {
  var l = core.normalizeList([{ name: 'x', proto: 'DoH', description: 'a\u0000b\nc' + 'z'.repeat(500) }]);
  assert.ok(!/[\u0000-\u001f]/.test(l.servers[0].description));
  assert.strictEqual(l.servers[0].description.length, 300);
});

test('validation: no server, too many servers, bad listen address, bad mark', function () {
  assert.ok(errors(state()).some(function (m) { return /at least one server/.test(m); }));
  var many = [];
  for (var i = 0; i < core.MAX_SERVERS + 1; i++) many.push(listServer('s' + i, 'dnscrypt'));
  assert.ok(errors(state({ servers: many })).some(function (m) { return /At most/.test(m); }));
  var one = [listServer('a', 'dnscrypt')];
  assert.ok(errors(state({ servers: one, listen: '127.0.0.1' })).length > 0);
  assert.ok(errors(state({ servers: one, listen: '300.0.0.1:53' })).length > 0);
  assert.ok(errors(state({ servers: one, listen: '127.0.0.1:0' })).length > 0);
  assert.ok(errors(state({ servers: one, socketMark: -1 })).length > 0);
  assert.ok(errors(state({ servers: one, socketMark: 1.5 })).length > 0);
  assert.deepStrictEqual(errors(state({ servers: one, socketMark: 4660 })), []);
  assert.ok(warnings(state({ servers: one, listen: '0.0.0.0:5359' })).some(function (m) { return /loopback/.test(m); }));
});

test('validation: names that could break the configuration are refused', function () {
  ["bad'name", 'bad name', 'a\nb', '', 'x]\ny'].forEach(function (n) {
    assert.ok(errors(state({ servers: [listServer(n, 'dnscrypt')] })).length > 0, JSON.stringify(n));
  });
  var c = { name: 'my.own', source: 'custom', kind: 'dnscrypt', stamp: DNSCRYPT, relays: null };
  assert.ok(errors(state({ servers: [c] })).some(function (m) { return /letters, digits/.test(m); }));
  var d = [listServer('dup', 'dnscrypt'), listServer('dup', 'doh')];
  assert.ok(errors(state({ servers: d })).some(function (m) { return /twice/.test(m); }));
});

test('validation: protocol switches and Oblivious DoH', function () {
  var s = state({ protocols: { dnscrypt: false, doh: true, odoh: false }, servers: [listServer('a', 'dnscrypt')] });
  assert.ok(errors(s).some(function (m) { return /DNSCrypt to be enabled/.test(m); }));
  var o = state({ protocols: { dnscrypt: true, doh: true, odoh: true }, servers: [listServer('o', 'odoh')] });
  assert.ok(errors(o).some(function (m) { return /only through a relay/.test(m); }));
  o.servers[0].relays = 'auto';
  assert.deepStrictEqual(errors(o), []);
  o.protocols.odoh = false;
  assert.ok(errors(o).some(function (m) { return /Oblivious DoH to be enabled/.test(m); }));
});

test('validation: relays', function () {
  var base = function (relays) { return state({ servers: [listServer('a', 'dnscrypt', null, relays)] }); };
  assert.deepStrictEqual(errors(base(['r1', 'r2'])), []);
  assert.deepStrictEqual(errors(base([RELAY])), []);
  assert.ok(errors(base([])).length > 0);
  assert.ok(errors(base(["bad'relay"])).length > 0);
  assert.ok(errors(base([DNSCRYPT])).length > 0);
  assert.ok(errors(base(['sdns://AQ'])).length > 0);
  assert.ok(warnings(base(['r1'])).some(function (m) { return /UDP/.test(m); }));
  var tcp = base(['r1']); tcp.forceTcp = true;
  assert.ok(!warnings(tcp).some(function (m) { return /UDP/.test(m); }));
});

test('validation: a server chosen by name is used even if it does not meet the required properties', function () {
  var s = state({ servers: [listServer('log', 'doh', { dnssec: false, nolog: false, nofilter: true })] });
  var w = warnings(s).join(' ');
  assert.ok(/DNSSEC/.test(w) && /no logging/.test(w) && !/no filtering/.test(w));
});

test('validation: a custom stamp that the daemon would refuse is an error', function () {
  var base = { name: 'mine', source: 'custom', kind: 'dnscrypt', relays: null };
  var bad = core.encodeStamp({ kind: 'dnscrypt', props: ZERO8, addr: '192.0.2.1', publicKey: new Uint8Array(31), provider: '2.dnscrypt-cert.example.com' });
  assert.ok(errors(state({ servers: [Object.assign({}, base, { stamp: bad })] })).some(function (m) { return /32 bytes/.test(m); }));
  var withPort = core.encodeStamp({ kind: 'doh', props: ZERO8, addr: '192.0.2.1:443', hashes: [], host: 'dns.example', path: '/x' });
  assert.ok(errors(state({ servers: [Object.assign({}, base, { kind: 'doh', stamp: withPort })] })).some(function (m) { return /must not have a port/.test(m); }));
  var quic = 'sdns://' + core.b64urlEncode(Uint8Array.of(4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0));
  assert.ok(errors(state({ servers: [Object.assign({}, base, { stamp: quic })] })).some(function (m) { return /not supported/.test(m); }));
  var odohRelay = core.encodeStamp({ kind: 'odohrelay', props: ZERO8, addr: '', hashes: [], host: 'relay.example', path: '/proxy' });
  assert.deepStrictEqual(errors(state({ servers: [listServer('a', 'dnscrypt', null, [odohRelay])] })), []);
});

test('validation: custom stamps', function () {
  var ok = { name: 'mine', source: 'custom', kind: 'dnscrypt', stamp: DNSCRYPT, relays: null };
  assert.deepStrictEqual(errors(state({ servers: [ok] })), []);
  var bad = Object.assign({}, ok, { stamp: 'sdns://AQ' });
  assert.ok(errors(state({ servers: [bad] })).length > 0);
  var relay = Object.assign({}, ok, { stamp: RELAY });
  assert.ok(errors(state({ servers: [relay] })).some(function (m) { return /relay stamp/.test(m); }));
  var dot = Object.assign({}, ok, { stamp: 'sdns://' + core.b64urlEncode(Uint8Array.of(3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)) });
  assert.ok(errors(state({ servers: [dot] })).some(function (m) { return /DNS-over-TLS/.test(m); }));
});

test('generate: servers from the list with defaults', function () {
  var t = core.generateToml(state({ servers: [listServer('example-dnscrypt-443', 'dnscrypt'), listServer('example-doh', 'doh')] }));
  assert.ok(t.indexOf("server_names = ['example-dnscrypt-443', 'example-doh']") !== -1);
  assert.ok(t.indexOf("listen_addresses = ['127.0.0.1:5359']") !== -1);
  assert.ok(t.indexOf('[sources.public-resolvers]') !== -1);
  assert.ok(t.indexOf('[sources.relays]') === -1 && t.indexOf('[anonymized_dns]') === -1 && t.indexOf('[static') === -1);
  assert.ok(t.indexOf('odoh_servers = false') !== -1 && t.indexOf('socket_mark') === -1);
  assert.ok(/\[monitoring_ui\]\nenabled = false/.test(t));
  assert.ok(t.indexOf('minisign_key') !== -1);
});

test('generate: top level keys come before every table', function () {
  var t = core.generateToml(state({ socketMark: 7, servers: [listServer('a', 'dnscrypt', null, ['r1'])] }));
  var firstTable = t.search(/^\s*\[/m);
  ['socket_mark = 7', 'server_names', 'force_tcp', 'http3', 'pqdnscrypt', 'bootstrap_resolvers', 'cache_size'].forEach(function (k) {
    assert.ok(t.indexOf(k) !== -1 && t.indexOf(k) < firstTable, k);
  });
});

test('generate: transport and protocol options', function () {
  var t = core.generateToml(state({ forceTcp: true, http3: true, pq: false, ipv6: true, servers: [listServer('a', 'dnscrypt')] }));
  ['force_tcp = true', 'http3 = true', 'pqdnscrypt = false', 'ipv6_servers = true'].forEach(function (k) {
    assert.ok(t.indexOf(k) !== -1, k);
  });
});

test('generate: anonymized routes, custom servers, Oblivious DoH', function () {
  var servers = [
    listServer('a', 'dnscrypt', null, ['r1', RELAY]),
    { name: 'mine', source: 'custom', kind: 'dnscrypt', stamp: DNSCRYPT, relays: 'auto' },
    listServer('o', 'odoh', null, 'auto')
  ];
  var t = core.generateToml(state({ protocols: { dnscrypt: true, doh: true, odoh: true }, servers: servers }));
  assert.ok(t.indexOf("{ server_name='a', via=['r1', '" + RELAY + "'] }") !== -1);
  assert.ok(t.indexOf("{ server_name='mine', via=['*'] }") !== -1);
  assert.ok(t.indexOf("{ server_name='o', via=['*'] }") !== -1);
  assert.ok(t.indexOf('skip_incompatible = true') !== -1);
  assert.ok(t.indexOf('[sources.relays]') !== -1 && t.indexOf('[sources.odoh-servers]') !== -1 && t.indexOf('[sources.odoh-relays]') !== -1);
  assert.ok(t.indexOf("  [static.mine]\n  stamp = '" + DNSCRYPT + "'") !== -1);
  assert.ok(t.indexOf('odoh_servers = true') !== -1);
});

test('generate: only custom servers and stamp relays need no resolver lists', function () {
  var t = core.generateToml(state({ servers: [{ name: 'mine', source: 'custom', kind: 'dnscrypt', stamp: DNSCRYPT, relays: [RELAY] }] }));
  assert.ok(t.indexOf('[sources') === -1);
});

test('generate: refuses invalid input', function () {
  assert.throws(function () { core.generateToml(state()); });
  assert.throws(function () { core.generateToml(state({ servers: [listServer("x'y", 'doh')] })); });
});

var dir = opt('--write');
if (dir) {
  fs.mkdirSync(dir, { recursive: true });
  var scenarios = {
    list: state({ servers: [listServer('SCALEWAY', 'dnscrypt'), listServer('DOHNAME', 'doh')] }),
    customdoh: state({ servers: [{ name: 'mydoh', source: 'custom', kind: 'doh', stamp: core.buildDohStamp({ url: 'https://cloudflare-dns.com/dns-query', dnssec: true, nolog: true }), relays: null }] }),
    odoh: state({ protocols: { dnscrypt: false, doh: false, odoh: true }, servers: [listServer('ODOHNAME', 'odoh', null, 'auto')] }),
    anon: state({ forceTcp: true, servers: [listServer('SCALEWAY', 'dnscrypt', null, ['RELAYNAME'])] }),
    placeholder: state({ servers: [{ name: 'mine', source: 'custom', kind: 'dnscrypt', stamp: core.withPort(DNSCRYPT, 8443), relays: [RELAY] }] })
  };
  Object.keys(scenarios).forEach(function (k) {
    fs.writeFileSync(path.join(dir, k + '.toml'), core.generateToml(scenarios[k]));
  });
  console.log('wrote ' + Object.keys(scenarios).length + ' configurations to ' + dir);
}

var listFile = opt('--list');
if (listFile) {
  var real = JSON.parse(fs.readFileSync(listFile, 'utf8'));
  test('real list: every stamp survives decode and encode (' + real.length + ' entries)', function () {
    var kinds = {};
    var bad = [];
    real.forEach(function (o) {
      if (typeof o.stamp !== 'string') return;
      try {
        var st = core.decodeStamp(o.stamp);
        kinds[st.kind] = (kinds[st.kind] || 0) + 1;
        if (core.encodeStamp(st) !== o.stamp) bad.push(o.name + ' (re-encoded differently)');
      } catch (e) {
        bad.push(o.name + ': ' + e.message);
      }
    });
    console.log('     kinds: ' + JSON.stringify(kinds));
    assert.deepStrictEqual(bad.slice(0, 5), []);
  });
  test('real list: description of each stamp matches the entry', function () {
    var checked = 0;
    real.forEach(function (o) {
      if (typeof o.stamp !== 'string') return;
      var st = core.decodeStamp(o.stamp);
      if (st.kind !== 'dnscrypt' && st.kind !== 'relay') return;
      var d = core.describeStamp(st);
      assert.ok(o.ports.indexOf(d.port) !== -1, o.name + ' port ' + d.port + ' not in ' + JSON.stringify(o.ports));
      checked++;
    });
    console.log('     checked ' + checked + ' DNSCrypt servers and relays');
    assert.ok(checked > 100);
  });
  test('real list: normalization keeps every known entry', function () {
    var l = core.normalizeList(real);
    var known = real.filter(function (o) { return /dnscrypt|doh/i.test(o.proto); }).length;
    assert.strictEqual(l.servers.length + l.relays.length, known);
    console.log('     servers ' + l.servers.length + ', relays ' + l.relays.length);
  });
}

console.log('\n' + passed + ' checks passed' + (process.exitCode ? ', some failed' : ''));
