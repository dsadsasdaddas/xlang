#!/usr/bin/env python3
"""Tiny concurrent HTTP load generator (stdlib only). Measures req/s under a
fixed concurrency for a fixed duration. Usage:
    python3 bench.py <host> <port> <seconds> <concurrency>"""
import http.client
import sys
import threading
import time


def main() -> None:
    host, port, seconds, conc = sys.argv[1], int(sys.argv[2]), float(sys.argv[3]), int(sys.argv[4])
    deadline = time.time() + seconds
    ok = [0]
    fail = [0]
    lock = threading.Lock()

    def worker() -> None:
        while time.time() < deadline:
            try:
                conn = http.client.HTTPConnection(host, port, timeout=5)
                conn.request("GET", "/")
                resp = conn.getresponse()
                resp.read()
                conn.close()
                with lock:
                    ok[0] += 1 if resp.status == 200 else 0
                    fail[0] += 0 if resp.status == 200 else 1
            except Exception:
                with lock:
                    fail[0] += 1

    threads = [threading.Thread(target=worker) for _ in range(conc)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    total = ok[0] + fail[0]
    print(f"{ok[0] / seconds:.0f} req/s  ({ok[0]} ok / {fail[0]} fail in {seconds}s @ {conc} conc)")


if __name__ == "__main__":
    main()
