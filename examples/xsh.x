module main

// xsh — a shell with pipes, redirects, and builtins.
//   cmd1 | cmd2          pipeline (2-stage)
//   cmd > file           redirect stdout to file
//   pwd / cd / exit      builtins
//   anything else        fork + exec via /bin/sh -c
// Reads one command per line from stdin:
//   printf "seq 1 5 | head -3\necho hi > /tmp/xsh.out\n" | ./xsh

fn run_simple(cmd: String): i32 {
    let pid: i32 = fork()
    if pid == 0 {
        exec_sh(cmd)
        return 1
    }
    wait_child()
    return 0
}

fn run_pipe(cmd1: String, cmd2: String): i32 {
    if make_pipe() < 0 {
        return 1
    }
    let r: i32 = pipe_read_end()
    let w: i32 = pipe_write_end()
    let p1: i32 = fork()
    if p1 == 0 {
        close_fd(r)
        dup2(w, 1)
        close_fd(w)
        exec_sh(cmd1)
        return 1
    }
    let p2: i32 = fork()
    if p2 == 0 {
        close_fd(w)
        dup2(r, 0)
        close_fd(r)
        exec_sh(cmd2)
        return 1
    }
    close_fd(r)
    close_fd(w)
    wait_child()
    wait_child()
    return 0
}

fn run_redirect(cmd: String, fname: String): i32 {
    let pid: i32 = fork()
    if pid == 0 {
        let fd: i32 = open_write(fname)
        dup2(fd, 1)
        close_fd(fd)
        exec_sh(cmd)
        return 1
    }
    wait_child()
    return 0
}

fn main(): i32 {
    while true {
        let cmd: String = read_line()
        if str_len(cmd) == 0 {
            return 0
        }
        if str_eq(cmd, "exit") {
            return 0
        }
        if str_eq(cmd, "pwd") {
            print_raw(getcwd())
            print_raw("\n")
        } else {
            if str_find(cmd, "cd ") == 0 {
                chdir(str_slice(cmd, 3, str_len(cmd)))
            } else {
                let pi: i32 = str_find(cmd, " | ")
                if pi >= 0 {
                    run_pipe(str_slice(cmd, 0, pi), str_slice(cmd, pi + 3, str_len(cmd)))
                } else {
                    let ri: i32 = str_find(cmd, " > ")
                    if ri >= 0 {
                        run_redirect(str_slice(cmd, 0, ri), str_slice(cmd, ri + 3, str_len(cmd)))
                    } else {
                        run_simple(cmd)
                    }
                }
            }
        }
    }
    return 0
}
