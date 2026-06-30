module main

// hostname — print the system hostname (reads /etc/hostname, like GNU hostname).
fn main(): i32 {
    let h: String = read_file("/etc/hostname")
    let n: i32 = str_len(h)
    let mut end: i32 = n
    if n > 0 {
        if str_char_at(h, n - 1) == 10 {
            end = n - 1
        }
    }
    print_raw(str_slice(h, 0, end))
    print_raw("\n")
    return 0
}
