#!/usr/bin/env python3
"""Parses the configurations written by fuzz.js (--out) with Python's tomllib.

    python3 tests/verify-toml.py cases.jsonl

It needs Python 3.11 or later. For every configuration that the page accepted it
checks that the file is valid TOML, that it holds only the expected keys and
tables (so nothing was injected), and that the values are the ones that were
asked for.
"""
import collections
import json
import sys
import tomllib

ALLOWED_TOP = {
    'listen_addresses', 'max_clients', 'ipv4_servers', 'ipv6_servers', 'dnscrypt_servers', 'doh_servers',
    'odoh_servers', 'require_dnssec', 'require_nolog', 'require_nofilter', 'server_names', 'force_tcp', 'http3',
    'pqdnscrypt', 'socket_mark', 'timeout', 'keepalive', 'use_syslog', 'bootstrap_resolvers', 'ignore_system_dns',
    'netprobe_timeout', 'netprobe_address', 'cache', 'cache_size', 'cache_min_ttl', 'cache_max_ttl',
    'cache_neg_min_ttl', 'cache_neg_max_ttl', 'monitoring_ui', 'sources', 'anonymized_dns', 'static',
}
ALLOWED_SOURCES = {'public-resolvers', 'relays', 'odoh-servers', 'odoh-relays'}


def check(case):
    problems = []
    st, toml = case['state'], case['toml']
    try:
        t = tomllib.loads(toml)
    except Exception as e:
        return ['does not parse: %s' % str(e)[:80]], None
    if set(t) - ALLOWED_TOP:
        problems.append('unexpected top-level keys %s' % sorted(set(t) - ALLOWED_TOP))
    if set(t.get('sources', {})) - ALLOWED_SOURCES:
        problems.append('unexpected source tables %s' % sorted(set(t['sources']) - ALLOWED_SOURCES))
    if t.get('server_names') != [s['name'] for s in st['servers']]:
        problems.append('server_names differ')
    customs = {s['name']: s['stamp'] for s in st['servers'] if s['source'] == 'custom'}
    if {k: v.get('stamp') for k, v in t.get('static', {}).items()} != customs:
        problems.append('static entries differ')
    for k, v in t.get('static', {}).items():
        if set(v) != {'stamp'}:
            problems.append('static entry %s has extra keys %s' % (k, sorted(v)))
    routes = t.get('anonymized_dns', {}).get('routes', [])
    want = [(s['name'], ['*'] if s['relays'] == 'auto' else s['relays']) for s in st['servers'] if s['relays']]
    if want != [(r['server_name'], r['via']) for r in routes]:
        problems.append('routes differ')
    for r in routes:
        if set(r) != {'server_name', 'via'}:
            problems.append('route has extra keys %s' % sorted(r))
    if t.get('listen_addresses') != [st['listen']]:
        problems.append('listen address differs')
    if t.get('bootstrap_resolvers') != st['bootstrap']:
        problems.append('bootstrap resolvers differ')
    mark = st['socketMark']
    if (mark and t.get('socket_mark') != mark) or (not mark and 'socket_mark' in t):
        problems.append('socket_mark differs')
    for key, expect in (('force_tcp', st['forceTcp']), ('http3', st['http3']), ('pqdnscrypt', st['pq']), ('ipv6_servers', st['ipv6']),
                        ('odoh_servers', st['protocols']['odoh']), ('doh_servers', st['protocols']['doh']),
                        ('dnscrypt_servers', st['protocols']['dnscrypt'])):
        if t.get(key) != expect:
            problems.append('%s differs' % key)
    if t.get('monitoring_ui') != {'enabled': False}:
        problems.append('the monitoring interface is not disabled')
    return problems, (bool(customs), bool(routes))


def main():
    path = sys.argv[1]
    n = 0
    bad = []
    mix = collections.Counter()
    for line in open(path):
        if not line.strip():
            continue
        n += 1
        problems, kind = check(json.loads(line))
        if problems:
            bad.append(problems)
        else:
            mix[kind] += 1
    print('%d accepted configurations parsed with tomllib, %d with problems' % (n, len(bad)))
    print('  (has custom servers, has routes):', dict(mix))
    for b in bad[:5]:
        print('  PROBLEM', b)
    sys.exit(1 if bad else 0)


main()
