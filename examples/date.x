module main

// date — print current date/time (like GNU date default format).
fn main(): i32 {
    print_raw(time_str())
    print_raw("\n")
    return 0
}
