module main

// mkfifo <path> — create a named pipe (FIFO) with mode 0644 (like GNU mkfifo).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: mkfifo <path>")
        return 1
    }
    return mkfifo(argv(1))
}
