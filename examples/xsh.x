module main

// xsh — a shell: N-stage pipelines, redirects (<, >, >>), builtins (pwd/cd/exit).
//   a | b | c          N-stage pipeline (up to 17 stages via a pipe pool)
//   cmd < in > out     input/output redirect; >> appends
//   pwd / cd DIR / exit  builtins
// Stages split on " | " (space-pipe-space). Reads one command per line from stdin:
//   printf "seq 1 10 | head -5 | tail -2\n" | ./xsh

fn split_pipe(s: String): Vec<String> {
    let v: Vec<String> = vec_new()
    let n: i32 = str_len(s)
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if i + 2 < n {
            if str_char_at(s, i) == 32 {
                if str_char_at(s, i + 1) == 124 {
                    if str_char_at(s, i + 2) == 32 {
                        v.push(str_slice(s, start, i))
                        start = i + 3
                        i = i + 3
                    } else {
                        i = i + 1
                    }
                } else {
                    i = i + 1
                }
            } else {
                i = i + 1
            }
        } else {
            i = i + 1
        }
    }
    v.push(str_slice(s, start, n))
    return v
}

fn close_all_pipes(npipes: i32): i32 {
    let mut j: i32 = 0
    while j < npipes {
        close_fd(pipe_r_at(j))
        close_fd(pipe_w_at(j))
        j = j + 1
    }
    return 0
}

fn run_pipeline(stages: Vec<String>): i32 {
    let ns: i32 = vec_len(stages)
    let npipes: i32 = ns - 1
    let mut i: i32 = 0
    while i < npipes {
        make_pipe_at(i)
        i = i + 1
    }
    let mut k: i32 = 0
    while k < ns {
        let pid: i32 = fork()
        if pid == 0 {
            if k > 0 {
                dup2(pipe_r_at(k - 1), 0)
            }
            if k < ns - 1 {
                dup2(pipe_w_at(k), 1)
            }
            close_all_pipes(npipes)
            exec_sh(stages[k])
            return 1
        }
        k = k + 1
    }
    close_all_pipes(npipes)
    let mut w: i32 = 0
    while w < ns {
        wait_child()
        w = w + 1
    }
    return 0
}

fn run_one(cmd: String): i32 {
    let mut core: String = cmd
    let mut infile: String = ""
    let mut outfile: String = ""
    let mut append: bool = false
    let ai: i32 = str_find(core, " >> ")
    if ai >= 0 {
        outfile = str_slice(core, ai + 4, str_len(core))
        core = str_slice(core, 0, ai)
        append = true
    } else {
        let oi: i32 = str_find(core, " > ")
        if oi >= 0 {
            outfile = str_slice(core, oi + 3, str_len(core))
            core = str_slice(core, 0, oi)
        }
    }
    let ii: i32 = str_find(core, " < ")
    if ii >= 0 {
        infile = str_slice(core, ii + 3, str_len(core))
        core = str_slice(core, 0, ii)
    }
    let pid: i32 = fork()
    if pid == 0 {
        if str_len(infile) > 0 {
            let fdi: i32 = open_read(infile)
            dup2(fdi, 0)
            close_fd(fdi)
        }
        if str_len(outfile) > 0 {
            let mut fdo: i32 = 0
            if append {
                fdo = open_append(outfile)
            } else {
                fdo = open_write(outfile)
            }
            dup2(fdo, 1)
            close_fd(fdo)
        }
        exec_sh(core)
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
                let stages: Vec<String> = split_pipe(cmd)
                if vec_len(stages) > 1 {
                    run_pipeline(stages)
                } else {
                    run_one(cmd)
                }
            }
        }
    }
    return 0
}
