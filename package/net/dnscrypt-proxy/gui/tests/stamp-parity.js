'use strict';

// Compares the stamp parser of this page with the one of dnscrypt-proxy.
//
//   node tests/stamp-parity.js --check /tmp/stampcheck [--list resolvers.json] [--n 200000] [--seed 1]
//
// --check  the program built from tests/stamp-parity/stampcheck.go (see there)
// --list   output of "dnscrypt-proxy -list-all -include-relays -json". Its stamps,
//          and damaged copies of them, are the test cases. Without it only made-up
//          stamps and hand-made edge cases are used.
//
// A custom stamp that the page accepts but the daemon refuses stops the daemon at
// start, so that is the failure. The page may be stricter than the daemon: such
// cases are only counted and a few reasons are shown.

var fs = require('fs');
var childProcess = require('child_process');
var core = require('../core.js');

var args = process.argv.slice(2);
function opt(name, dflt) {
  var i = args.indexOf(name);
  return i === -1 ? dflt : args[i + 1];
}
var CHECK = opt('--check', null);
if (!CHECK) { console.error('give --check <program built from stampcheck.go>'); process.exit(2); }
var N = Number(opt('--n', 200000));
var SEED = Number(opt('--seed', 1));

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

var Z8 = new Uint8Array(8), KEY = new Uint8Array(32), HASH = new Uint8Array(32);
var seeds = [
  'sdns://AQcAAAAAAAAADTE5Mi4wLjIuMTo0NDMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMi5kbnNjcnlwdC1jZXJ0LmV4YW1wbGUuY29t',
  'sdns://gQ0xOTIuMC4yLjI6NDQz'
];
if (opt('--list', null)) {
  seeds = seeds.concat(JSON.parse(fs.readFileSync(opt('--list'), 'utf8')).map(function (o) { return o.stamp; }).filter(Boolean));
}

// hand-made edge cases around the rules of the parser
var edge = [];
function add(o) { try { edge.push(core.encodeStamp(o)); } catch (e) { /* too long to encode */ } }
['192.0.2.1:443', '192.0.2.1', '[2001:db8::1]:443', '[2001:db8::1]', '2001:db8::1', '192.0.2.1:', '192.0.2.1:0', '192.0.2.1:65535', '192.0.2.1:65536',
  '192.0.2.1:00443', '192.0.2.1:+443', '192.0.2.1: 443', '01.2.3.4:443', '1.2.3:443', 'dns.example:443', '', ':443', '[::1]:443', '[::]:443', '[1::]:443',
  '[1:2:3:4:5:6:7::]:443', '[1:2:3:4:5:6:7:8::]:443', '[::ffff:1.2.3.4]:443', '[::ffff:1.2.3.04]:443', '[fe80::1%eth0]:443', '[1:2:3:4:5:6:7:8:9]:443',
  '[12345::1]:443', '[1::2::3]:443', '[:::]:443', '[[::1]]:443', '[::1]]:443', '[::1:443', '::1:443'].forEach(function (a) {
  add({ kind: 'dnscrypt', props: Z8, addr: a, publicKey: KEY, provider: '2.dnscrypt-cert.example.com' });
  add({ kind: 'relay', addr: a });
  add({ kind: 'doh', props: Z8, addr: a, hashes: [], host: 'dns.example', path: '/x' });
  add({ kind: 'odohrelay', props: Z8, addr: a, hashes: [], host: 'relay.example', path: '/x' });
});
['dns.example', 'dns.example:443', 'dns.example:', 'dns.example:0', 'dns.example:65536', 'dns.example:00443', '[::1]', '[::1]:443', '[::1]:', '::1', 'a:b:c',
  '', ':', ':443', 'dns.example:443:443', 'dns.example:4 43', 'dns.example\u00e9'].forEach(function (h) {
  add({ kind: 'doh', props: Z8, addr: '', hashes: [], host: h, path: '/x' });
  add({ kind: 'odohtarget', props: Z8, host: h, path: '/x' });
  add({ kind: 'odohrelay', props: Z8, addr: '', hashes: [], host: h, path: '/x' });
});
[[], [HASH], [HASH, HASH], [new Uint8Array(0)], [new Uint8Array(31)], [new Uint8Array(33)], [HASH, new Uint8Array(1)]].forEach(function (hs) {
  add({ kind: 'doh', props: Z8, addr: '', hashes: hs, host: 'dns.example', path: '/x' });
});
[0, 1, 5, 7, 31, 32, 33].forEach(function (n) {
  add({ kind: 'dnscrypt', props: Z8, addr: '192.0.2.1:443', publicKey: new Uint8Array(n), provider: '2.dnscrypt-cert.example.com' });
});
[[], [1, 0x31], [7, 0x31, 0x2e, 0x32, 0x2e, 0x33, 0x2e, 0x34], [0x81, 0x31, 0], [0x81, 0x31, 1, 0x31], [0], [0, 0], [9, 1], [0x80], [0x80, 0]].forEach(function (t) {
  add({ kind: 'doh', props: Z8, addr: '', hashes: [], host: 'dns.example', path: '/x', tail: Uint8Array.from(t) });
  add({ kind: 'odohrelay', props: Z8, addr: '', hashes: [], host: 'dns.example', path: '/x', tail: Uint8Array.from(t) });
});
['', 'a', 'a'.repeat(30), 'a'.repeat(200)].forEach(function (p) {
  add({ kind: 'dnscrypt', props: Z8, addr: '192.0.2.1:443', publicKey: KEY, provider: p });
  add({ kind: 'doh', props: Z8, addr: '', hashes: [], host: 'd', path: p });
  add({ kind: 'odohtarget', props: Z8, host: 'd', path: p });
});

function mutate(s) {
  var body = Array.from(core.b64urlDecode(s.slice(7)));
  var k = ri(6);
  if (k === 0 && body.length) body[ri(body.length)] ^= 1 << ri(8);
  else if (k === 1) body.length = ri(body.length + 1);
  else if (k === 2) for (var i = ri(8); i >= 0; i--) body.push(ri(256));
  else if (k === 3 && body.length) body[ri(body.length)] = ri(256);
  else if (k === 4 && body.length > 2) body.splice(ri(body.length), ri(3));
  else if (body.length) { var j = ri(body.length); body[j] = pick([0, 1, 31, 32, 33, 58, 91, 93, 0x80, 0xff]); }
  return 'sdns://' + core.b64urlEncode(Uint8Array.from(body));
}

var cases = seeds.concat(edge);
for (var i = 0; i < N; i++) cases.push(mutate(pick(seeds)));
cases = cases.filter(function (s) { return s.indexOf('\n') === -1; });

// only the stamp types that the page handles itself
var HANDLED = { 0x01: 1, 0x02: 1, 0x05: 1, 0x81: 1, 0x85: 1 };
cases = cases.filter(function (s) {
  try { return HANDLED[core.b64urlDecode(s.slice(7))[0]]; } catch (e) { return false; }
});

var out = childProcess.execFileSync(CHECK, { input: cases.join('\n') + '\n', maxBuffer: 1 << 28 }).toString().split('\n');
if (out.length < cases.length) { console.error('the checker answered ' + out.length + ' lines for ' + cases.length + ' stamps'); process.exit(2); }

var bothOk = 0, bothNo = 0, stricter = 0;
var danger = [];
var reasons = {};
cases.forEach(function (s, idx) {
  var theirs = out[idx];
  var ours = null, why = '';
  try { core.decodeStamp(s); ours = true; } catch (e) { ours = false; why = e.message; }
  var daemonOk = theirs === 'ok';
  if (ours && daemonOk) bothOk++;
  else if (!ours && !daemonOk) bothNo++;
  else if (ours && !daemonOk) danger.push(s + '  (daemon: ' + theirs + ')');
  else { stricter++; reasons[why] = (reasons[why] || 0) + 1; }
});

console.log(cases.length + ' stamps (' + seeds.length + ' seeds, ' + edge.length + ' hand-made edge cases, the rest damaged copies)');
console.log('both accept: ' + bothOk + ', both refuse: ' + bothNo + ', only the page refuses: ' + stricter + ', only the daemon refuses: ' + danger.length);
Object.keys(reasons).sort(function (a, b) { return reasons[b] - reasons[a]; }).slice(0, 8).forEach(function (r) {
  console.log('  page is stricter (' + reasons[r] + '): ' + r);
});
if (danger.length) {
  console.log('PROBLEM: the page accepts stamps that the daemon refuses. First cases:');
  danger.slice(0, 8).forEach(function (d) { console.log('  ' + d); });
  process.exit(1);
}
console.log('RESULT PASS');
