module main

// pwd — print the current working directory (like GNU pwd). Uses getcwd().
fn main(): i32 {
    print_raw(getcwd())
    print_raw("\n")
    return 0
}
