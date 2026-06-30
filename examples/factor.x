module main

// factor <n> — prime factorization (like GNU factor). Uses trial division.
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: factor <n>")
        return 1
    }
    let n: i32 = str_to_int(argv(1))
    let mut remaining: i32 = n
    let mut d: i32 = 2
    print_raw(int_to_str(n))
    print_raw(":")
    while d * d <= remaining {
        while remaining % d == 0 {
            print_raw(" ")
            print_raw(int_to_str(d))
            remaining = remaining / d
        }
        d += 1
    }
    if remaining > 1 {
        print_raw(" ")
        print_raw(int_to_str(remaining))
    }
    print_raw("\n")
    return 0
}
