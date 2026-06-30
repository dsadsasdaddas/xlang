module main

// epoll event-loop HTTP server (keepalive) — nginx's architecture. A SINGLE
// process multiplexes every connection through one epoll fd. Listen socket
// ready -> accept + register client; client ready -> recv request, respond,
// keep the connection open (level-triggered EPOLLIN re-fires on the next
// request). recv==0 means the peer closed -> del + close. No fork, no
// thread-per-connection: scales to thousands of concurrent keepalive
// connections where a prefork model saturates at worker-count.
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
            if str_len(req) == 0 {
                epoll_del(fd)
                close_fd(fd)
            } else {
                send_str(fd, "HTTP/1.1 200 OK\r\nContent-Length: 5\r\nConnection: keep-alive\r\n\r\nhello")
            }
        }
    }
    return 0
}
