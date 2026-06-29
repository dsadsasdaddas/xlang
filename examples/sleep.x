module main

// sleep <seconds> — pause for N seconds (like GNU sleep).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: sleep <seconds>")
        return 1
    }
    sleep_sec(str_to_int(argv(1)))
    return 0
}
