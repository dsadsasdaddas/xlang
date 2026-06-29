module main

// echo <args> — prints its arguments separated by spaces (like GNU echo).
fn main(): i32 {
    let mut i: i32 = 1
    while i < argc() {
        if i > 1 {
            print_raw(" ")
        }
        print_raw(argv(i))
        i += 1
    }
    print_raw("\n")
    return 0
}
