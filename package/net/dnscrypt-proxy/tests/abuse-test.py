#!/usr/bin/env python3
"""Hostile input against a running dnscrypt-proxy. See README.md in this directory.

    abuse-test.py --port 5359 --pid <pid of the daemon>

It sends 6000 malformed UDP packets (0 to 65507 bytes, many with a header that
claims too many records), a name with a compression loop, a name longer than 255
bytes, and 400 idle or half-open TCP connections. After each step the daemon must
still be running and must still answer a normal query.

Exit status: 0 the daemon survived every step, 1 it died or stopped answering.
"""
import argparse
import os
import random
import socket
import struct
import sys
import time

ap = argparse.ArgumentParser()
ap.add_argument('--port', type=int, required=True)
ap.add_argument('--pid', type=int, required=True)
args = ap.parse_args()
random.seed(11)
failed = []


def alive():
    try:
        os.kill(args.pid, 0)
        return True
    except OSError:
        return False


def query(name='example.com', timeout=10):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.settimeout(timeout)
    m = struct.pack('>HHHHHH', random.randint(0, 65535), 0x0100, 1, 0, 0, 0)
    for p in name.split('.'):
        m += bytes([len(p)]) + p.encode()
    s.sendto(m + b'\x00' + struct.pack('>HH', 1, 1), ('127.0.0.1', args.port))
    try:
        r, _ = s.recvfrom(4096)
        return struct.unpack('>H', r[2:4])[0] & 0xf
    except OSError:
        return None


def report(label):
    ok = alive() and query() == 0
    print('%s: %s' % (label, 'daemon alive and answering' if ok else 'FAILED'))
    if not ok:
        failed.append(label)


report('before')
u = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sizes = [0, 1, 2, 11, 12, 13, 64, 512, 1232, 4096, 65000, 65507]
for i in range(6000):
    n = random.choice(sizes) if i % 3 == 0 else random.randint(0, 600)
    b = os.urandom(n)
    if i % 4 == 0 and n >= 12:
        counts = struct.pack('>HHHHH', 0x0100, random.choice([1, 0, 65535]), random.choice([0, 65535]),
                             random.choice([0, 65535]), random.choice([0, 65535]))
        b = b[:2] + counts + b[12:]
    try:
        u.sendto(b, ('127.0.0.1', args.port))
    except OSError:
        pass
report('after 6000 malformed UDP packets')

loop = struct.pack('>HHHHHH', 1, 0x0100, 1, 0, 0, 0) + b'\xc0\x0c' + struct.pack('>HH', 1, 1)
long_name = struct.pack('>HHHHHH', 2, 0x0100, 1, 0, 0, 0) + b''.join(bytes([63]) + c * 63 for c in (b'a', b'b', b'c', b'd')) + b'\x00' + struct.pack('>HH', 1, 1)
for packet in (loop, long_name):
    u.sendto(packet, ('127.0.0.1', args.port))
time.sleep(1)
report('after a compression loop and a name longer than 255 bytes')

conns = []
for i in range(400):
    try:
        c = socket.create_connection(('127.0.0.1', args.port), timeout=2)
        if i % 3 == 1:
            c.sendall(b'\x01\x00')               # a length prefix and no message
        elif i % 3 == 2:
            c.sendall(os.urandom(300))           # garbage
        conns.append(c)
    except OSError:
        break
print('opened %d TCP connections and hold them for 6 s' % len(conns))
time.sleep(6)
for c in conns:
    try:
        c.close()
    except OSError:
        pass
time.sleep(2)
report('after closing the TCP connections')

if failed:
    print('RESULT FAIL: %s' % '; '.join(failed))
    sys.exit(1)
print('RESULT PASS')
