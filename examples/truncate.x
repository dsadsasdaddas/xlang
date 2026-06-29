module main

// truncate <file> <size> — set file to exactly N bytes (like GNU truncate -s).
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: truncate <file> <size>")
        return 1
    }
    return truncate_file(argv(1), str_to_int(argv(2)))
}
