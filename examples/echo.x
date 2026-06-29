module main

// echo [-n] <args> — print arguments separated by spaces (like GNU echo).
// -n suppresses the trailing newline.
fn main(): i32 {
    let mut i: i32 = 1
    let mut newline: bool = true
    let mut first_print: bool = true
    if argc() >= 2 {
        if str_eq(argv(1), "-n") {
            newline = false
            i = 2
        }
    }
    while i < argc() {
        if !first_print {
            print_raw(" ")
        }
        print_raw(argv(i))
        first_print = false
        i += 1
    }
    if newline {
        print_raw("\n")
    }
    return 0
}
