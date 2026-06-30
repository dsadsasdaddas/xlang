module main

// mkdir <dir> — create a directory (like GNU mkdir, mode 0755).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: mkdir <dir>")
        return 1
    }
    return make_dir(argv(1))
}
