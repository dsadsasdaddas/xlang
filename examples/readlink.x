module main

// readlink <path> — print the target of a symbolic link (like GNU readlink).
// Pairs with ln (which creates symlinks).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: readlink <path>")
        return 1
    }
    let target: String = readlink(argv(1))
    if str_len(target) == 0 {
        return 1
    }
    print_raw(target)
    print_raw("\n")
    return 0
}
