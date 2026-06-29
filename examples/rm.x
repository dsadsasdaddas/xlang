module main

// rm <file> — remove a file (like GNU rm). Returns the remove() exit code.
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: rm <file>")
        return 1
    }
    return remove_file(argv(1))
}
