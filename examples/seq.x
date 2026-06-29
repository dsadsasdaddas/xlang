module main

// seq <n> — print numbers 1..n (like GNU seq). Uses str_to_int to parse the
// argument (the builtin added so xlang can convert strings to numbers).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: seq <n>")
        return 1
    }
    let n: i32 = str_to_int(argv(1))
    let mut i: i32 = 1
    while i <= n {
        print_raw(int_to_str(i))
        print_raw("\n")
        i += 1
    }
    return 0
}
