'use strict';

// Fuzzing of ../core.js.
//
//   node tests/fuzz.js [--list resolvers.json] [--seed N] [--out cases.jsonl] [--n1 200000] [--n2 40000]
//
// Part 1 gives the stamp decoder random and damaged input. It must never throw
// anything but an Error, never take long, and every stamp it accepts must survive
// decode and encode.
// Part 2 gives validation and generation hostile settings. A configuration is
// generated if and only if validation finds no error. The accepted configurations
// are written to --out as JSON lines, so that tests/verify-toml.py can parse them
// again with a TOML parser that is independent of this code.
//
// --list is the output of "dnscrypt-proxy -list-all -include-relays -json". Without
// it, only made-up stamps are damaged.

var fs = require('fs');
var core = require('../core.js');

var args = process.argv.slice(2);
function opt(name, dflt) {
  var i = args.indexOf(name);
  return i === -1 ? dflt : args[i + 1];
}
var SEED = Number(opt('--seed', 1));
var OUT = opt('--out', null);
var N1 = Number(opt('--n1', 200000));
var N2 = Number(opt('--n2', 40000));

function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    var t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
var rnd = mulberry32(SEED);
function ri(n) { return Math.floor(rnd() * n); }
function pick(a) { return a[ri(a.length)]; }

// Stamps made with an independent encoder, in the documentation address range 192.0.2.0/24.
var PLACE_DNSCRYPT = 'sdns://AQcAAAAAAAAADTE5Mi4wLjIuMTo0NDMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMi5kbnNjcnlwdC1jZXJ0LmV4YW1wbGUuY29t';
var PLACE_RELAY = 'sdns://gQ0xOTIuMC4yLjI6NDQz';
var real = [PLACE_DNSCRYPT, PLACE_RELAY];
var listFile = opt('--list', null);
if (listFile) {
  real = JSON.parse(fs.readFileSync(listFile, 'utf8')).map(function (o) { return o.stamp; }).filter(Boolean);
}

// ---- part 1 ---------------------------------------------------------------

function randBytes(n) { return Uint8Array.from({ length: n }, function () { return ri(256); }); }
function mutate(s) {
  var body = Array.from(core.b64urlDecode(s.slice(7)));
  var k = ri(5);
  if (k === 0 && body.length) body[ri(body.length)] ^= 1 << ri(8);
  else if (k === 1) body.length = ri(body.length + 1);
  else if (k === 2) for (var i = ri(8); i >= 0; i--) body.push(ri(256));
  else if (k === 3 && body.length) body[ri(body.length)] = ri(256);
  else if (k === 4 && body.length > 2) body.splice(ri(body.length), ri(3));
  return 'sdns://' + core.b64urlEncode(Uint8Array.from(body));
}
function norm(x) {
  return JSON.stringify(x, function (key, v) {
    if (v instanceof Uint8Array) return Array.from(v);
    if (Array.isArray(v) && v[0] instanceof Uint8Array) return v.map(function (u) { return Array.from(u); });
    return v;
  });
}

var reasons = {};
var accepted = 0, rejected = 0, slow = 0, notCanonical = 0;
var bugs = [];
var t0 = Date.now();
for (var n = 0; n < N1; n++) {
  var s;
  var kind = ri(4);
  if (kind === 0) {
    s = 'sdns://' + Array.from({ length: ri(60) }, function () { return 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_=+/ !'[ri(68)]; }).join('');
  } else if (kind === 1) {
    var b = randBytes(ri(90));
    if (b.length && rnd() < 0.8) b[0] = pick([1, 2, 3, 4, 5, 0x81, 0x85]);
    s = 'sdns://' + core.b64urlEncode(b);
  } else {
    s = mutate(pick(real));
  }
  var t = Date.now();
  try {
    var st = core.decodeStamp(s);
    accepted++;
    if (st.kind === 'dnscrypt' || st.kind === 'doh' || st.kind === 'relay') {
      var e = core.encodeStamp(st);
      if (norm(st) !== norm(core.decodeStamp(e))) bugs.push('round trip differs: ' + s);
      if (e !== s) notCanonical++;
    }
    try { core.describeStamp(st); } catch (err) {
      if (!(err instanceof Error) || err.constructor !== Error) bugs.push('describe threw ' + (err && err.constructor && err.constructor.name));
    }
  } catch (err) {
    rejected++;
    var name = err && err.constructor ? err.constructor.name : typeof err;
    if (name !== 'Error') bugs.push('decode threw ' + name + ': ' + String(err && err.message));
    var key = name + ': ' + String(err && err.message).slice(0, 60);
    reasons[key] = (reasons[key] || 0) + 1;
  }
  if (Date.now() - t > 50) slow++;
}
console.log('part 1: ' + N1 + ' inputs in ' + (Date.now() - t0) + ' ms: accepted ' + accepted + ', rejected ' + rejected +
  ', slower than 50 ms: ' + slow + ', accepted but not canonical: ' + notCanonical);
Object.keys(reasons).sort(function (a, b) { return reasons[b] - reasons[a]; }).slice(0, 6).forEach(function (k) {
  console.log('  ' + String(reasons[k]).padStart(7) + '  ' + k);
});
console.log('part 1 problems: ' + bugs.length + (bugs.length ? '\n  ' + bugs.slice(0, 5).join('\n  ') : ''));

// ---- part 2 ---------------------------------------------------------------

var ALPHA = ['abc', 'ABC-xyz_09', 'a.b', "it's", 'x\ny', 'x\r\ny', 'a]b', '[x]', 'a"b', 'a\\b', '#c', 'a = b', '\u00e9', '\u540d\u524d', '\u0000', ' ', '', 'a'.repeat(70),
  "']\nodoh_servers = true\n[x]\n'", "x'\n[static.evil]\nstamp='sdns://AQ'\n#", '*', 'sdns://', '=', '..', 'a b', '-lead', '.lead'];
function rname() { return rnd() < 0.55 ? 'srv' + ri(30) : pick(ALPHA) + (rnd() < 0.3 ? pick(ALPHA) : ''); }
var LISTEN = ['127.0.0.1:5359', '[::1]:5359', '0.0.0.0:53', '127.0.0.1', '127.0.0.1:0', '1.2.3.4:99999', '', "127.0.0.1:53'", '999.1.1.1:53', 'x:53', '127.0.0.1:5359\nfoo=1'];
var BOOT = ['9.9.9.9:53', '1.1.1.1:53', '[2001:db8::1]:53', 'bad', '9.9.9.9', "1.1.1.1:53'", '8.8.8.8:53\nx=1', '256.1.1.1:53', ''];
var STAMPS = [PLACE_DNSCRYPT, PLACE_RELAY, 'sdns://AQ', 'x', '', "sdns://AQ'",
  function () { return mutate(pick(real)); }, function () { return pick(real); }];
function rstamp() { var x = pick(STAMPS); return typeof x === 'function' ? x() : x; }
function rrelays() {
  var k = ri(6);
  if (k === 0) return null;
  if (k === 1) return 'auto';
  if (k === 2) return [];
  return Array.from({ length: 1 + ri(3) }, function () { return rnd() < 0.3 ? rstamp() : rname(); });
}
function rstate() {
  return {
    listen: pick(LISTEN), protocols: { dnscrypt: rnd() < 0.8, doh: rnd() < 0.8, odoh: rnd() < 0.5 }, ipv6: rnd() < 0.3,
    require: { dnssec: rnd() < 0.7, nolog: rnd() < 0.7, nofilter: rnd() < 0.7 }, forceTcp: rnd() < 0.3, http3: rnd() < 0.3, pq: rnd() < 0.8,
    socketMark: pick([0, 0, 0, 1, 4660, 2147483647, 2147483648, -1, 1.5, NaN, '7']),
    bootstrap: Array.from({ length: ri(4) }, function () { return pick(BOOT); }),
    servers: Array.from({ length: ri(11) }, function () {
      return {
        name: rname(), source: pick(['list', 'custom']), kind: pick(['dnscrypt', 'doh', 'odoh']), stamp: rstamp(), relays: rrelays(),
        flags: rnd() < 0.7 ? { dnssec: rnd() < 0.5, nolog: rnd() < 0.5, nofilter: rnd() < 0.5 } : undefined
      };
    })
  };
}
// Mostly valid settings in which each field turns hostile with probability h.
function rstate2(h) {
  function hostile() { return rnd() < h; }
  var servers = [];
  var count = 1 + ri(8);
  for (var i = 0; i < count; i++) {
    var custom = rnd() < 0.5;
    var kind = pick(['dnscrypt', 'dnscrypt', 'doh', 'odoh']);
    var relays = null;
    if (kind === 'odoh') relays = rnd() < 0.5 ? 'auto' : ['relay' + ri(5)];
    else if (rnd() < 0.4) relays = rnd() < 0.3 ? 'auto' : Array.from({ length: 1 + ri(2) }, function () { return rnd() < 0.3 ? PLACE_RELAY : 'relay' + ri(5); });
    if (hostile()) relays = rrelays();
    servers.push({
      name: hostile() ? rname() : (custom ? 'c' : 's') + i + '-x_y',
      source: custom ? 'custom' : 'list', kind: kind, stamp: custom ? (hostile() ? rstamp() : PLACE_DNSCRYPT) : undefined, relays: relays,
      flags: custom ? undefined : { dnssec: rnd() < 0.8, nolog: rnd() < 0.8, nofilter: rnd() < 0.8 }
    });
  }
  return {
    listen: hostile() ? pick(LISTEN) : '127.0.0.1:' + (1024 + ri(60000)), protocols: { dnscrypt: true, doh: true, odoh: true }, ipv6: rnd() < 0.3,
    require: { dnssec: rnd() < 0.7, nolog: rnd() < 0.7, nofilter: rnd() < 0.7 }, forceTcp: rnd() < 0.5, http3: rnd() < 0.5, pq: rnd() < 0.8,
    socketMark: hostile() ? pick([0, -1, 1.5, NaN, '7', 2147483648]) : ri(3) === 0 ? ri(100000) : 0,
    bootstrap: hostile() ? Array.from({ length: ri(4) }, function () { return pick(BOOT); }) : ['9.9.9.9:53', '1.1.1.1:53'], servers: servers
  };
}

var lines = [];
var valid = 0, refused = 0;
var bugs2 = [];
for (var m = 0; m < N2; m++) {
  var state = m % 2 === 0 ? rstate() : rstate2(pick([0, 0.02, 0.05, 0.1]));
  var errs;
  try { errs = core.validate(state).filter(function (p) { return p.level === 'error'; }); } catch (e1) {
    bugs2.push('validate threw ' + e1.name + ': ' + e1.message);
    continue;
  }
  var toml = null, gerr = null;
  try { toml = core.generateToml(state); } catch (e2) { gerr = e2; }
  if (errs.length === 0) {
    if (gerr) { bugs2.push('valid settings but generateToml threw: ' + gerr.message); continue; }
    valid++;
    lines.push(JSON.stringify({ ok: true, state: state, toml: toml }));
  } else {
    if (!gerr) bugs2.push('settings with errors but generateToml succeeded: ' + errs[0].msg);
    refused++;
  }
}
if (OUT) fs.writeFileSync(OUT, lines.join('\n') + '\n');
console.log('part 2: ' + N2 + ' hostile settings: valid ' + valid + ', refused ' + refused + ', inconsistencies ' + bugs2.length);
if (bugs2.length) console.log('  ' + bugs2.slice(0, 5).join('\n  '));
process.exitCode = bugs.length + bugs2.length ? 1 : 0;
