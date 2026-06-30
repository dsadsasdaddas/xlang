module main

// Looping HTTP server (blocking, one connection at a time) — the honest
// baseline for benchmarking against nginx. Run on the server:
//   xlangc c examples/server_loop.x && cc -O2 -o srv build/server_loop.c && ./srv
//   curl http://localhost:28080/
fn main(): i32 {
    let fd: i32 = tcp_listen(28080)
    while true {
        let client: i32 = accept(fd)
        let req: String = recv_str(client)
        send_str(client, "HTTP/1.1 200 OK\r\nContent-Length: 5\r\n\r\nhello")
        close_fd(client)
    }
    return 0
}
