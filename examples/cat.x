module main

// cat [file] — print file contents (or stdin if no file). Like GNU cat.
fn main(): i32 {
    let mut content: String = ""
    if argc() >= 2 {
        content = read_file(argv(1))
    } else {
        content = read_stdin()
    }
    print_raw(content)
    return 0
}
