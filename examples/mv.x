module main

// mv <src> <dst> — rename/move a file (like GNU mv). Uses rename().
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: mv <src> <dst>")
        return 1
    }
    return rename_file(argv(1), argv(2))
}
