module main

// xsh — a minimal shell. Reads commands line by line from stdin and executes
// each via system(). On EOF (empty line), exits. This is the defining Linux
// userland component: a command interpreter written in xlang.
//   printf "echo hello\nseq 1 3\n" | ./xsh
fn main(): i32 {
    while true {
        let cmd: String = read_line()
        if str_len(cmd) == 0 {
            return 0
        }
        system(cmd)
    }
    return 0
}
