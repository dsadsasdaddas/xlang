module main

// Minimal single-request HTTP server. Build & run on Linux:
//   xlangc c examples/server.x && cc -o server build/server.c && ./server
//   curl http://localhost:8080
fn main(): i32 {
    let fd: i32 = tcp_listen(8080)
    let client: i32 = accept(fd)
    let req: String = recv_str(client)
    let body: String = "hello from xlang"
    let header: String = str_concat(str_concat("HTTP/1.1 200 OK\r\nContent-Length: ", int_to_str(str_len(body))), "\r\n\r\n")
    let resp: String = str_concat(header, body)
    send_str(client, resp)
    close_fd(client)
    close_fd(fd)
    return 0
}
