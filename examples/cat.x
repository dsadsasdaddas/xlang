module main

// cat <file> — the classic Unix utility. Reads a file given as a command-line
// argument and prints its contents (like GNU cat).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: cat <file>")
        return 1
    }
    let content: String = read_file(argv(1))
    print_raw(content)
    return 0
}
