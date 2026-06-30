module main

// Prefork keepalive server that serves a real file per request (read_file +
// send, userspace copy) — to benchmark against nginx's sendfile (zero-copy) on
// a realistic workload. 16 workers isolate file-serving efficiency from
// concurrency. payload path is absolute so cwd doesn't matter.
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
            let body: String = read_file("/home/wzu/payload.txt")
            let len: i32 = str_len(body)
            let resp: String = str_concat(str_concat("HTTP/1.1 200 OK\r\nContent-Length: ", int_to_str(len)), str_concat("\r\n\r\n", body))
            send_str(client, resp)
        }
        close_fd(client)
    }
    return 0
}
