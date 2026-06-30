module main

// rmdir <dir> — remove an empty directory (like GNU rmdir). Pairs with mkdir.
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: rmdir <dir>")
        return 1
    }
    return rmdir(argv(1))
}
