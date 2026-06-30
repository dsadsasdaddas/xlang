module main

// epoll event-loop HTTP server — nginx's architecture. A SINGLE process
// multiplexes every connection through one epoll fd: epoll_wait returns the
// next ready fd. Listen socket ready -> accept + register client; client ready
// -> read request, respond, close. No fork, no thread-per-connection, so it
// scales to thousands of concurrent connections where a prefork model saturates.
fn main(): i32 {
    let listen_fd: i32 = tcp_listen(28081)
    epoll_create()
    epoll_add(listen_fd)
    while true {
        let fd: i32 = epoll_wait(-1)
        if fd == listen_fd {
            let client: i32 = accept(listen_fd)
            set_nonblock(client)
            epoll_add(client)
        } else {
            let req: String = recv_str(fd)
            if str_len(req) > 0 {
                send_str(fd, "HTTP/1.1 200 OK\r\nContent-Length: 5\r\n\r\nhello")
            }
            epoll_del(fd)
            close_fd(fd)
        }
    }
    return 0
}
