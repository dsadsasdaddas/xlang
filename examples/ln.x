module main

// ln <target> <link> — create a symbolic link (like `ln -s`).
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: ln <target> <link>")
        return 1
    }
    return symlink(argv(1), argv(2))
}
