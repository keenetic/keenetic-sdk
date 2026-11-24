'use strict';

// Drives index.html in a simulated browser.
// Needs jsdom, which is not part of this directory:
//   npm install jsdom            (in any directory)
//   NODE_PATH=<that>/node_modules node tests/ui.test.js

var assert = require('assert');
var fs = require('fs');
var path = require('path');
var JSDOM = require('jsdom').JSDOM;
var core = require('../core.js');

var root = path.join(__dirname, '..');
var sample = JSON.parse(fs.readFileSync(path.join(root, 'sample-resolvers.json'), 'utf8'));
var DNSCRYPT = 'sdns://AQcAAAAAAAAADTE5Mi4wLjIuMTo0NDMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAbMi5kbnNjcnlwdC1jZXJ0LmV4YW1wbGUuY29t';

var passed = 0;
function step(name, fn) {
  try {
    fn();
    passed++;
    console.log('ok   ' + name);
  } catch (e) {
    console.log('FAIL ' + name + '\n     ' + String(e && e.stack).split('\n').slice(0, 3).join('\n     '));
    process.exitCode = 1;
  }
}

JSDOM.fromFile(path.join(root, 'index.html'), { runScripts: 'dangerously', resources: 'usable' }).then(function (dom) {
  var w = dom.window;
  var d = w.document;
  var $ = function (id) { return d.getElementById(id); };
  function fire(e, type) { e.dispatchEvent(new w.Event(type, { bubbles: true })); }
  function set(id, v) { $(id).value = v; fire($(id), 'input'); fire($(id), 'change'); }
  function check(id, on) { $(id).checked = on; fire($(id), 'change'); }
  function mode(m) { var r = d.querySelector('input[name="mode"][value="' + m + '"]'); r.checked = true; fire(r, 'change'); }
  function anon(m) { var r = d.querySelector('input[name="anon"][value="' + m + '"]'); r.checked = true; fire(r, 'change'); }
  function click(id) { $(id).dispatchEvent(new w.MouseEvent('click', { bubbles: true, cancelable: true })); }
  function pick(name) { set('pick', name); }
  function rows() { return d.querySelectorAll('#server-table tbody tr').length; }
  function names() { return w.DnsCryptApp.state().servers.map(function (s) { return s.name; }); }
  function same(a, b, msg) { assert.strictEqual(JSON.stringify(a), JSON.stringify(b), msg); }
  function addErrors() { return $('add-errors').textContent; }

  function run() {
    step('the page starts with the default options and no servers', function () {
      assert.strictEqual(rows(), 0);
      assert.ok(/at least one server/i.test($('problems').textContent));
      assert.strictEqual($('copy-toml').disabled, true);
      assert.ok(/Fix the errors/.test($('toml').value));
    });

    w.DnsCryptApp.loadList(sample);

    step('a loaded list is reported', function () {
      assert.ok(/6 servers and 3 relays/.test($('list-status').textContent));
    });

    step('the add panel opens and lists DNSCrypt and DoH servers, without the IPv6-only one', function () {
      assert.strictEqual($('add-panel').hidden, true);
      click('add-link');
      assert.strictEqual($('add-panel').hidden, false);
      assert.strictEqual($('pick').options.length, 4);
    });

    step('filters narrow the list', function () {
      check('f-443', true);
      assert.strictEqual($('pick').options.length, 3);
      check('f-nofilter', true);
      assert.strictEqual($('pick').options.length, 2);
      set('f-text', 'doh');
      assert.strictEqual($('pick').options.length, 1);
      check('f-443', false); check('f-nofilter', false); set('f-text', '');
      assert.strictEqual($('pick').options.length, 4);
      check('f-ipv6', true);
      assert.strictEqual($('pick').options.length, 5);
    });

    step('save a server from the list', function () {
      pick('example-dnscrypt-443');
      assert.ok(/no logs/.test($('pick-info').textContent));
      click('save-server');
      assert.strictEqual($('add-panel').hidden, true);
      same(names(), ['example-dnscrypt-443']);
      assert.strictEqual(rows(), 1);
      assert.strictEqual($('copy-toml').disabled, false);
      assert.ok($('toml').value.indexOf("server_names = ['example-dnscrypt-443']") !== -1);
    });

    step('a server chosen by name that does not meet the required properties gets a note', function () {
      click('add-link');
      pick('example-doh-logging');
      click('save-server');
      assert.strictEqual(addErrors(), '');
      assert.ok(names().indexOf('example-doh-logging') !== -1);
      assert.ok(/does not advertise DNSSEC, no logging/.test($('problems').textContent));
    });

    step('add a custom DNSCrypt stamp and change its port', function () {
      click('add-link');
      mode('stamp');
      set('stamp-name', 'mine');
      set('stamp-input', DNSCRYPT);
      assert.ok(/DNSCrypt: 192\.0\.2\.1 port 443/.test($('stamp-info').textContent));
      set('stamp-port', '8443');
      click('stamp-port-apply');
      assert.ok(/port 8443/.test($('stamp-info').textContent));
      assert.notStrictEqual($('stamp-input').value, DNSCRYPT);
      click('save-server');
      assert.ok(names().indexOf('mine') !== -1);
      var s = w.DnsCryptApp.state().servers.filter(function (x) { return x.name === 'mine'; })[0];
      assert.strictEqual(core.describeStamp(s.stamp).port, 8443);
    });

    step('a bad stamp and a bad port are refused with a message', function () {
      click('add-link');
      mode('stamp');
      set('stamp-name', 'broken');
      set('stamp-input', 'sdns://AQ');
      assert.ok(/Not valid/.test($('stamp-info').textContent));
      var badText = Array.from(core.b64urlDecode(DNSCRYPT.slice(7)));
      badText[badText.length - 1] = 0xff;
      set('stamp-input', 'sdns://' + core.b64urlEncode(Uint8Array.from(badText)));
      assert.ok(/not valid UTF-8/.test($('stamp-info').textContent), $('stamp-info').textContent);
      assert.ok(!/encoded data/.test($('stamp-info').textContent));
      set('stamp-input', 'sdns://AQ');
      click('save-server');
      assert.ok(/valid DNSCrypt/.test(addErrors()));
      set('stamp-input', DNSCRYPT);
      set('stamp-port', '70000');
      click('stamp-port-apply');
      assert.ok(/Not changed/.test($('stamp-info').textContent));
      click('cancel-server');
      assert.strictEqual($('add-panel').hidden, true);
    });

    step('add a personal DNS-over-HTTPS address', function () {
      click('add-link');
      mode('doh');
      set('doh-name', 'my-doh');
      set('doh-url', 'http://dns.example/x');
      assert.ok(/Not valid/.test($('doh-info').textContent));
      click('save-server');
      assert.ok(/not valid/.test(addErrors()));
      set('doh-url', 'https://dns.example/abc123');
      assert.ok(/^Stamp: sdns:\/\//.test($('doh-info').textContent));
      click('save-server');
      assert.ok(names().indexOf('my-doh') !== -1);
      assert.strictEqual(w.DnsCryptApp.state().servers.slice(-1)[0].relays, null);
    });

    step('a plain DoH server cannot be given a relay', function () {
      click('add-link');
      mode('list');
      pick('example-doh');
      assert.strictEqual(d.querySelector('input[name="anon"][value="auto"]').disabled, true);
      assert.ok(/DNSCrypt and Oblivious DoH servers only/.test($('anon-note').textContent));
      click('cancel-server');
    });

    step('Oblivious DoH needs a relay', function () {
      check('p-odoh', true);
      click('add-link');
      check('f-odoh', true);
      pick('example-odoh');
      assert.ok(/needs a relay/.test($('anon-note').textContent));
      click('save-server');
      assert.ok(/only through a relay/.test(addErrors()));
      assert.strictEqual(names().indexOf('example-odoh'), -1);
      anon('choose');
      assert.strictEqual($('relay-pick').options.length, 1);
      assert.strictEqual($('relay-pick').options[0].value, 'example-odoh-relay');
      anon('auto');
      click('save-server');
      assert.ok(names().indexOf('example-odoh') !== -1);
      assert.ok($('toml').value.indexOf("{ server_name='example-odoh', via=['*'] }") !== -1);
    });

    step('relays are offered for DNSCrypt servers and can be chosen', function () {
      click('add-link');
      check('f-odoh', false);
      pick('example-dnscrypt-8443');
      anon('choose');
      assert.strictEqual($('relay-pick').options.length, 2);
      $('relay-pick').options[0].selected = true;
      $('relay-pick').options[1].selected = true;
      click('save-server');
      assert.strictEqual(addErrors(), '', 'the server was not saved');
      var s = w.DnsCryptApp.state().servers.filter(function (x) { return x.name === 'example-dnscrypt-8443'; })[0];
      same(s.relays, ['example-relay-1', 'example-relay-2']);
      assert.ok(/UDP/.test($('problems').textContent));
    });

    step('the eighth server is accepted and the ninth is refused', function () {
      var n = names().length;
      var items = w.DnsCryptApp.state().servers;
      while (items.length < core.MAX_SERVERS) {
        items.push({ name: 'fill' + items.length, source: 'list', kind: 'dnscrypt', relays: null, flags: { dnssec: true, nolog: true, nofilter: true } });
      }
      w.DnsCryptApp.render();
      assert.ok(n <= core.MAX_SERVERS);
      assert.ok(!/At most/.test($('problems').textContent));
      click('add-link');
      check('f-odoh', false);
      pick('example-doh');
      click('save-server');
      assert.ok(/At most 8/.test(addErrors()));
      assert.strictEqual(names().indexOf('example-doh'), -1);
      click('cancel-server');
    });

    step('server names and descriptions from a list are never interpreted as HTML', function () {
      w.DnsCryptApp.state().servers.length = 0;
      w.DnsCryptApp.loadList([{ name: '<img src=x onerror=alert(1)>', proto: 'DoH', ports: [443], dnssec: true, nolog: true, nofilter: true, description: '<script>window.pwned=1</script><b>x</b>' }]);
      click('add-link');
      assert.strictEqual($('pick').options.length, 1);
      pick('<img src=x onerror=alert(1)>');
      assert.strictEqual($('add-panel').querySelectorAll('img, script, b').length, 0);
      assert.ok(/<script>/.test($('pick-info').textContent));
      click('save-server');
      assert.ok(/unsupported characters/.test(addErrors()));
      assert.strictEqual(w.DnsCryptApp.state().servers.length, 0);
      assert.ok(!w.pwned);
      click('cancel-server');
    });

    step('a list file that is not a list is reported', function () {
      assert.throws(function () { core.normalizeList('x'); });
    });

    step('options change the configuration', function () {
      w.DnsCryptApp.loadList(sample);
      click('add-link'); pick('example-dnscrypt-443'); click('save-server');
      check('o-tcp', true); check('o-http3', true); check('o-pq', false); check('p-ipv6', true);
      set('o-mark', '4660');
      set('o-listen', '127.0.0.1:5400');
      set('o-bootstrap', '9.9.9.9:53');
      var t = $('toml').value;
      ['force_tcp = true', 'http3 = true', 'pqdnscrypt = false', 'ipv6_servers = true', 'socket_mark = 4660', "listen_addresses = ['127.0.0.1:5400']", "bootstrap_resolvers = ['9.9.9.9:53']"]
        .forEach(function (k) { assert.ok(t.indexOf(k) !== -1, k); });
      set('o-listen', 'nonsense');
      assert.ok(/listen address/i.test($('problems').textContent));
      assert.ok(/Fix the errors/.test($('toml').value));
    });

    console.log('\n' + passed + ' steps passed' + (process.exitCode ? ', some failed' : ''));
    w.close();
  }

  if (d.readyState === 'complete') run();
  else w.addEventListener('load', run);
});
