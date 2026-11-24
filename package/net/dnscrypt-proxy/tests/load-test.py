#!/usr/bin/env python3
"""Load test for a running dnscrypt-proxy. See README.md in this directory.

    load-test.py --port 5359 --pid <pid of the daemon> [--duration 480] [--hup-at 240]

Six clients send queries at about 40 per second for the given time. 3 percent of the
names are unique, so they have to go to an upstream server, and the rest come from
a small set, so they are answered from the cache. Every 30 seconds the memory,
thread count, open file count and CPU time of the daemon are read from /proc.
With --hup-at the daemon gets SIGHUP once, after that many seconds.

Exit status: 0 every query was answered and the daemon is still running,
             1 a query got no answer or another error code, or the daemon died.
"""
import argparse
import os
import random
import re
import signal
import socket
import struct
import sys
import threading
import time

ap = argparse.ArgumentParser()
ap.add_argument('--port', type=int, required=True)
ap.add_argument('--pid', type=int, required=True)
ap.add_argument('--duration', type=int, default=480)
ap.add_argument('--hup-at', type=int, default=0)
ap.add_argument('--clients', type=int, default=6)
args = ap.parse_args()

NAMES = ['example.com', 'cloudflare.com', 'wikipedia.org', 'example.org', 'example.net'] + ['host%02d.example.com' % i for i in range(35)]
lock = threading.Lock()
results = []
stop = threading.Event()


def build(name):
    m = struct.pack('>HHHHHH', random.randint(0, 65535), 0x0100, 1, 0, 0, 0)
    for p in name.split('.'):
        m += bytes([len(p)]) + p.encode()
    return m + b'\x00' + struct.pack('>HH', 1, 1)


def worker():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(8)
    rnd = random.Random()
    while not stop.is_set():
        unique = rnd.random() < 0.03
        name = ('u%08x.example.com' % rnd.getrandbits(32)) if unique else rnd.choice(NAMES)
        q = build(name)
        t = time.time()
        try:
            s.sendto(q, ('127.0.0.1', args.port))
            r, _ = s.recvfrom(4096)
            rc = struct.unpack('>H', r[2:4])[0] & 0xf if r[:2] == q[:2] else 99
        except OSError:
            rc = None
        with lock:
            results.append(('u' if unique else 'c', time.time() - t, rc))
        time.sleep(0.15)


def sample():
    st = open('/proc/%d/status' % args.pid).read()
    rss = int(re.search(r'VmRSS:\s+(\d+)', st).group(1))
    threads = int(re.search(r'Threads:\s+(\d+)', st).group(1))
    fds = len(os.listdir('/proc/%d/fd' % args.pid))
    f = open('/proc/%d/stat' % args.pid).read().split(')')[1].split()
    cpu = (int(f[11]) + int(f[12])) / os.sysconf('SC_CLK_TCK')
    return rss, threads, fds, cpu


for _ in range(args.clients):
    threading.Thread(target=worker, daemon=True).start()
t0 = time.time()
samples = []
hup_done = False
died = False
while time.time() - t0 < args.duration:
    time.sleep(30)
    elapsed = int(time.time() - t0)
    try:
        samples.append((elapsed,) + sample())
    except (OSError, AttributeError):
        died = True
        break
    if args.hup_at and not hup_done and elapsed >= args.hup_at:
        os.kill(args.pid, signal.SIGHUP)
        hup_done = True
        print('SIGHUP sent after %d s' % elapsed)
stop.set()
time.sleep(1)


def pct(values, p):
    values = sorted(values)
    return values[min(len(values) - 1, int(len(values) * p))] if values else float('nan')


total = len(results)
answered = sum(1 for k, l, rc in results if rc in (0, 3))      # NOERROR or NXDOMAIN
timeouts = sum(1 for k, l, rc in results if rc is None)
other = total - answered - timeouts
print('queries sent: %d, answered: %d, other answers: %d, timeouts: %d' % (total, answered, other, timeouts))
for kind, label in (('c', 'cached names'), ('u', 'unique names (upstream)')):
    v = [l for k, l, rc in results if k == kind and rc in (0, 3)]
    print('  %-24s n=%-6d p50=%6.1f ms  p95=%6.1f ms  p99=%6.1f ms  max=%7.1f ms' % (
        label, len(v), pct(v, .5) * 1000, pct(v, .95) * 1000, pct(v, .99) * 1000, max(v or [0]) * 1000))
print('samples of the daemon (seconds, VmRSS kB, threads, open files, CPU seconds):')
for s in samples:
    print('  ', s)
warm = [s for s in samples if s[0] >= 90]
if len(warm) >= 2:
    print('after warm-up: VmRSS %d -> %d kB, threads %d -> %d, open files %d -> %d' % (
        warm[0][1], warm[-1][1], warm[0][2], warm[-1][2], warm[0][3], warm[-1][3]))
if samples:
    print('mean CPU use: %.1f%% of one core' % (100 * samples[-1][4] / max(1, samples[-1][0])))
if died:
    print('RESULT FAIL: the daemon is gone')
    sys.exit(1)
if timeouts or other or total == 0:
    print('RESULT FAIL: not every query was answered')
    sys.exit(1)
print('RESULT PASS')
