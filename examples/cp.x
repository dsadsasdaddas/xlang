module main

// cp <src> <dst> — copy a file (like GNU cp). Text-safe (read_file is
// null-terminated, so binary files with NUL bytes would truncate).
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: cp <src> <dst>")
        return 1
    }
    let content: String = read_file(argv(1))
    write_file(argv(2), content)
    return 0
}
