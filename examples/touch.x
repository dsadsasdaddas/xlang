module main

// touch <file> — create an empty file or truncate existing (like GNU touch
// for creation; does not update mtime if the file already exists).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: touch <file>")
        return 1
    }
    write_file(argv(1), "")
    return 0
}
