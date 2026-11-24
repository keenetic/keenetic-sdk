'use strict';

// Wires the page to DnsCryptCore. Text that comes from a file or from the user
// is only ever put into the page with textContent, never as HTML.

(function () {
  var core = window.DnsCryptCore;
  var state = core.defaultState();
  var lists = { servers: [], relays: [] };
  var KIND_LABEL = { dnscrypt: 'DNSCrypt', doh: 'DNS-over-HTTPS', odoh: 'Oblivious DoH' };

  function $(id) {
    return document.getElementById(id);
  }
  function el(tag, props, children) {
    var e = document.createElement(tag);
    Object.keys(props || {}).forEach(function (k) {
      if (k === 'text') e.textContent = props[k];
      else if (k === 'class') e.className = props[k];
      else e.setAttribute(k, props[k]);
    });
    (children || []).forEach(function (c) {
      e.appendChild(c);
    });
    return e;
  }
  function clear(node) {
    while (node.firstChild) node.removeChild(node.firstChild);
  }
  function radio(name) {
    var r = document.querySelector('input[name="' + name + '"]:checked');
    return r ? r.value : '';
  }
  function findServer(name) {
    return lists.servers.filter(function (s) { return s.name === name; })[0] || null;
  }

  // ---- table of servers ---------------------------------------------------

  function relayText(s) {
    if (!s.relays) return 'None';
    if (s.relays === 'auto') return 'Automatic';
    return s.relays.map(function (r) { return /^sdns:\/\//.test(r) ? 'relay stamp' : r; }).join(', ');
  }

  function addressText(s) {
    if (s.source === 'custom') {
      try {
        var d = core.describeStamp(s.stamp);
        return (d.address || d.name || 'see stamp') + (d.port ? ':' + d.port : '');
      } catch (e) {
        return 'see stamp';
      }
    }
    var item = findServer(s.name);
    return item && item.ports.length ? 'port ' + item.ports.join(', ') : 'from the list';
  }

  function renderTable() {
    var body = document.querySelector('#server-table tbody');
    clear(body);
    state.servers.forEach(function (s, i) {
      var del = el('button', { type: 'button', class: 'link', text: 'Delete' });
      del.addEventListener('click', function () {
        state.servers.splice(i, 1);
        render();
      });
      body.appendChild(el('tr', {}, [
        el('td', { text: s.name }),
        el('td', { text: KIND_LABEL[s.kind] || s.kind }),
        el('td', { text: addressText(s) }),
        el('td', { text: relayText(s) }),
        el('td', { text: s.source === 'custom' ? 'Custom' : 'List' }),
        el('td', {}, [del])
      ]));
    });
    $('empty-note').hidden = state.servers.length > 0;
    $('max-servers').textContent = String(core.MAX_SERVERS);
  }

  // ---- result -------------------------------------------------------------

  function renderProblems(target, problems) {
    clear(target);
    if (!problems.length) return;
    var ul = el('ul');
    problems.forEach(function (p) {
      ul.appendChild(el('li', { class: p.level, text: (p.level === 'error' ? 'Error: ' : 'Note: ') + p.msg }));
    });
    target.appendChild(ul);
  }

  function renderResult() {
    var problems = core.validate(state);
    renderProblems($('problems'), problems);
    var hasError = problems.some(function (p) { return p.level === 'error'; });
    $('toml').value = hasError ? 'Fix the errors above to create the configuration.' : core.generateToml(state);
    $('copy-toml').disabled = hasError;
  }

  function render() {
    renderTable();
    renderResult();
  }

  // ---- options ------------------------------------------------------------

  function readOptions() {
    state.protocols = { dnscrypt: $('p-dnscrypt').checked, doh: $('p-doh').checked, odoh: $('p-odoh').checked };
    state.ipv6 = $('p-ipv6').checked;
    state.forceTcp = $('o-tcp').checked;
    state.http3 = $('o-http3').checked;
    state.pq = $('o-pq').checked;
    state.require = { dnssec: $('r-dnssec').checked, nolog: $('r-nolog').checked, nofilter: $('r-nofilter').checked };
    state.listen = $('o-listen').value.trim();
    state.bootstrap = $('o-bootstrap').value.split(',').map(function (x) { return x.trim(); }).filter(Boolean);
    var m = $('o-mark').value.trim();
    state.socketMark = m === '' ? 0 : Number(m);
    render();
  }

  // ---- the "Add server" panel ---------------------------------------------

  function filterValues() {
    return {
      kinds: { dnscrypt: $('f-dnscrypt').checked, doh: $('f-doh').checked, odoh: $('f-odoh').checked },
      port443: $('f-443').checked,
      dnssec: $('f-dnssec').checked,
      nolog: $('f-nolog').checked,
      nofilter: $('f-nofilter').checked,
      ipv6: $('f-ipv6').checked,
      text: $('f-text').value
    };
  }

  function renderPick() {
    var sel = $('pick');
    var old = sel.value;
    clear(sel);
    var shown = core.filterServers(lists.servers, filterValues());
    shown.slice(0, 500).forEach(function (s) {
      var label = s.name + '  (' + KIND_LABEL[s.kind] + ', port ' + (s.ports.join('/') || '?') + ')';
      var o = el('option', { value: s.name, text: label });
      if (s.name === old) o.selected = true;
      sel.appendChild(o);
    });
    $('pick-info').textContent = shown.length > 500
      ? shown.length + ' servers match. Showing the first 500. Use the filters.'
      : shown.length + ' servers match.';
    renderPickInfo();
    renderRelayPick();
  }

  function flagText(s) {
    return [s.dnssec ? 'DNSSEC' : 'no DNSSEC', s.nolog ? 'no logs' : 'may keep logs', s.nofilter ? 'no filtering' : 'filters content'].join(', ');
  }

  function renderPickInfo() {
    var s = findServer($('pick').value);
    if (s) $('pick-info').textContent = KIND_LABEL[s.kind] + '. ' + flagText(s) + '. ' + s.description;
  }

  function candidateKind() {
    var mode = radio('mode');
    if (mode === 'list') {
      var s = findServer($('pick').value);
      return s ? s.kind : null;
    }
    if (mode === 'doh') return 'doh';
    try {
      var st = core.decodeStamp($('stamp-input').value.trim());
      if (st.kind === 'dnscrypt' || st.kind === 'doh') return st.kind;
      if (st.proto === 0x05) return 'odoh';
    } catch (e) {
      return null;
    }
    return null;
  }

  function renderRelayPick() {
    var kind = candidateKind();
    var sel = $('relay-pick');
    var keep = Array.prototype.filter.call(sel.options, function (o) { return o.selected; }).map(function (o) { return o.value; });
    clear(sel);
    lists.relays
      .filter(function (r) { return kind === 'odoh' ? r.kind === 'odoh' : r.kind === 'dnscrypt'; })
      .slice(0, 500)
      .forEach(function (r) {
        var o = el('option', { value: r.name, text: r.name + '  (port ' + (r.ports.join('/') || '?') + ')' });
        if (keep.indexOf(r.name) !== -1) o.selected = true;
        sel.appendChild(o);
      });
    var plainDoh = kind === 'doh';
    Array.prototype.forEach.call(document.querySelectorAll('input[name="anon"]'), function (r) { r.disabled = plainDoh; });
    if (plainDoh) document.querySelector('input[name="anon"][value="none"]').checked = true;
    $('relay-choose').hidden = radio('anon') !== 'choose';
    $('anon-note').textContent = plainDoh
      ? 'Relays are used with DNSCrypt and Oblivious DoH servers only.'
      : kind === 'odoh' ? 'Oblivious DoH needs a relay.' : '';
  }

  function renderMode() {
    var mode = radio('mode');
    $('mode-list').hidden = mode !== 'list';
    $('mode-stamp').hidden = mode !== 'stamp';
    $('mode-doh').hidden = mode !== 'doh';
    renderRelayPick();
  }

  function renderStampInfo() {
    var v = $('stamp-input').value.trim();
    var out = $('stamp-info');
    if (!v) {
      out.textContent = '';
    } else {
      try {
        var d = core.describeStamp(v);
        out.textContent = d.protoName + (d.address || d.name ? ': ' + (d.address || d.name) + (d.port ? ' port ' + d.port : '') : '') + (d.path ? ' ' + d.path : '');
      } catch (e) {
        out.textContent = 'Not valid: ' + e.message + '.';
      }
    }
    renderRelayPick();
  }

  function renderDohInfo() {
    var url = $('doh-url').value.trim();
    var out = $('doh-info');
    if (!url) {
      out.textContent = '';
      return;
    }
    try {
      var stamp = core.buildDohStamp(dohOptions());
      out.textContent = 'Stamp: ' + stamp;
    } catch (e) {
      out.textContent = 'Not valid: ' + e.message + '.';
    }
  }

  function dohOptions() {
    return {
      url: $('doh-url').value,
      ip: $('doh-ip').value,
      dnssec: $('doh-dnssec').checked,
      nolog: $('doh-nolog').checked,
      nofilter: $('doh-nofilter').checked
    };
  }

  function relaysFromForm(kind) {
    if (kind === 'doh') return null;
    var a = radio('anon');
    if (a === 'auto') return 'auto';
    if (a !== 'choose') return null;
    var names = Array.prototype.filter.call($('relay-pick').options, function (o) { return o.selected; }).map(function (o) { return o.value; });
    var extra = $('relay-extra').value.split('\n').map(function (x) { return x.trim(); }).filter(Boolean);
    return names.concat(extra);
  }

  function buildCandidate() {
    var mode = radio('mode');
    var cand;
    if (mode === 'list') {
      var item = findServer($('pick').value);
      if (!item) return { error: 'Choose a server from the list.' };
      cand = { name: item.name, source: 'list', kind: item.kind, flags: { dnssec: item.dnssec, nolog: item.nolog, nofilter: item.nofilter } };
    } else if (mode === 'stamp') {
      var kind = candidateKind();
      if (!kind) return { error: 'Enter a valid DNSCrypt, DNS-over-HTTPS or Oblivious DoH stamp.' };
      cand = { name: $('stamp-name').value.trim(), source: 'custom', kind: kind, stamp: $('stamp-input').value.trim() };
    } else {
      try {
        cand = { name: $('doh-name').value.trim(), source: 'custom', kind: 'doh', stamp: core.buildDohStamp(dohOptions()) };
      } catch (e) {
        return { error: 'The address is not valid: ' + e.message + '.' };
      }
    }
    cand.relays = relaysFromForm(cand.kind);
    return { server: cand };
  }

  function saveServer() {
    var built = buildCandidate();
    var out = $('add-errors');
    if (built.error) {
      renderProblems(out, [{ level: 'error', msg: built.error }]);
      return;
    }
    var trial = Object.assign({}, state, { servers: state.servers.concat([built.server]) });
    var field = 'server:' + built.server.name;
    var problems = core.validate(trial).filter(function (p) { return p.field === field || p.field === 'servers' && state.servers.length >= core.MAX_SERVERS; });
    renderProblems(out, problems);
    if (problems.some(function (p) { return p.level === 'error'; })) return;
    state.servers.push(built.server);
    closePanel();
    render();
  }

  function openPanel() {
    $('add-panel').hidden = false;
    renderPick();
    renderMode();
  }
  function closePanel() {
    $('add-panel').hidden = true;
    clear($('add-errors'));
  }

  // ---- resolver list ------------------------------------------------------

  function loadList(json) {
    lists = core.normalizeList(json);
    $('list-status').textContent = 'Loaded ' + lists.servers.length + ' servers and ' + lists.relays.length + ' relays.';
    renderPick();
    render();
  }

  function readListFile(file) {
    var reader = new FileReader();
    reader.onload = function () {
      try {
        loadList(JSON.parse(String(reader.result)));
      } catch (e) {
        $('list-status').textContent = 'The file could not be used: ' + e.message + '.';
      }
    };
    reader.readAsText(file);
  }

  function loadSample() {
    if (typeof fetch !== 'function') return;
    fetch('sample-resolvers.json')
      .then(function (r) { return r.json(); })
      .then(function (j) {
        loadList(j);
        $('list-status').textContent += ' These are sample entries. Open a resolver list file for real servers.';
      })
      .catch(function () {
        $('list-status').textContent = 'No list is loaded. Open a resolver list file.';
      });
  }

  // ---- events -------------------------------------------------------------

  function init() {
    ['p-dnscrypt', 'p-doh', 'p-odoh', 'p-ipv6', 'o-tcp', 'o-http3', 'o-pq', 'r-dnssec', 'r-nolog', 'r-nofilter', 'o-listen', 'o-bootstrap', 'o-mark']
      .forEach(function (id) {
        $(id).addEventListener('input', readOptions);
        $(id).addEventListener('change', readOptions);
      });
    $('add-link').addEventListener('click', function (e) {
      e.preventDefault();
      openPanel();
    });
    $('cancel-server').addEventListener('click', closePanel);
    $('save-server').addEventListener('click', saveServer);
    Array.prototype.forEach.call(document.querySelectorAll('input[name="mode"]'), function (r) { r.addEventListener('change', renderMode); });
    Array.prototype.forEach.call(document.querySelectorAll('input[name="anon"]'), function (r) { r.addEventListener('change', renderRelayPick); });
    ['f-dnscrypt', 'f-doh', 'f-odoh', 'f-443', 'f-dnssec', 'f-nolog', 'f-nofilter', 'f-ipv6', 'f-text']
      .forEach(function (id) { $(id).addEventListener('input', renderPick); $(id).addEventListener('change', renderPick); });
    $('pick').addEventListener('change', function () { renderPickInfo(); renderRelayPick(); });
    $('stamp-input').addEventListener('input', renderStampInfo);
    $('stamp-port-apply').addEventListener('click', function () {
      try {
        $('stamp-input').value = core.withPort($('stamp-input').value.trim(), Number($('stamp-port').value));
      } catch (e) {
        $('stamp-info').textContent = 'Not changed: ' + e.message + '.';
        return;
      }
      renderStampInfo();
    });
    ['doh-url', 'doh-ip', 'doh-dnssec', 'doh-nolog', 'doh-nofilter']
      .forEach(function (id) { $(id).addEventListener('input', renderDohInfo); $(id).addEventListener('change', renderDohInfo); });
    $('list-file').addEventListener('change', function () {
      if (this.files && this.files[0]) readListFile(this.files[0]);
    });
    $('copy-toml').addEventListener('click', function () {
      var t = $('toml');
      t.select();
      var done = function (ok) { $('copy-status').textContent = ok ? 'Copied.' : 'Select the text and copy it.'; };
      if (navigator.clipboard && navigator.clipboard.writeText) navigator.clipboard.writeText(t.value).then(function () { done(true); }, function () { done(false); });
      else done(false);
    });
    readOptions();
    loadSample();
  }

  window.DnsCryptApp = {
    state: function () { return state; },
    loadList: loadList,
    render: render
  };

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', init);
  else init();
})();
