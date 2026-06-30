#!/usr/bin/env python3
"""Multiprocess HTTP load generator (bypasses the GIL). N processes each make
serial requests as fast as possible for T seconds; aggregate req/s.
Usage: python3 bench_mp.py <host> <port> <seconds> <procs>"""
import http.client
import multiprocessing
import sys
import time


def worker(host: str, port: int, seconds: float, q) -> None:
    deadline = time.time() + seconds
    ok = 0
    while time.time() < deadline:
        try:
            conn = http.client.HTTPConnection(host, port, timeout=5)
            conn.request("GET", "/")
            resp = conn.getresponse()
            resp.read()
            conn.close()
            ok += resp.status == 200
        except Exception:
            pass
    q.put(ok)


def main() -> None:
    host, port, seconds, procs = sys.argv[1], int(sys.argv[2]), float(sys.argv[3]), int(sys.argv[4])
    mgr = multiprocessing.Manager()
    q = mgr.Queue()
    jobs = [multiprocessing.Process(target=worker, args=(host, port, seconds, q)) for _ in range(procs)]
    for j in jobs:
        j.start()
    for j in jobs:
        j.join()
    total = sum(q.get() for _ in range(procs))
    print(f"{total / seconds:.0f} req/s  ({total} ok in {seconds}s @ {procs} procs)")


if __name__ == "__main__":
    main()
