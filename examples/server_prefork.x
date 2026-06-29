module main

// Prefork keepalive server: fork N workers, each runs a blocking keepalive
// accept-loop on the shared listen socket. This is the "modify x" answer to
// the keepalive gap — N workers serve N connections in parallel (the prefork
// model nginx/apache use). Workers = 1 + (loop count).
fn main(): i32 {
    let fd: i32 = tcp_listen(28080)
    let mut i: i32 = 0
    while i < 15 {
        let pid: i32 = fork()
        if pid == 0 {
            break
        }
        i += 1
    }
    while true {
        let client: i32 = accept(fd)
        while true {
            let req: String = recv_str(client)
            if str_len(req) == 0 {
                break
            }
            send_str(client, "HTTP/1.1 200 OK\r\nContent-Length: 5\r\n\r\nhello")
        }
        close_fd(client)
    }
    return 0
}
