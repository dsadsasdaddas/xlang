module main

// link <existing> <new> — create a hard link (like GNU link). Complements
// ln (which creates symbolic links).
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: link <existing> <new>")
        return 1
    }
    return link_file(argv(1), argv(2))
}
