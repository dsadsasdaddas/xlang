module main

// uptime — print system uptime in seconds (from /proc/uptime).
fn main(): i32 {
    let u: String = read_file("/proc/uptime")
    let n: i32 = str_len(u)
    let mut i: i32 = 0
    let mut val: i32 = 0
    while i < n {
        let c: i32 = str_char_at(u, i)
        if c >= 48 {
            if c <= 57 {
                val = val * 10 + (c - 48)
            }
        }
        if c == 46 {
            break
        }
        if c == 32 {
            break
        }
        i += 1
    }
    print_raw(str_concat(str_concat("up ", int_to_str(val)), " seconds\n"))
    return 0
}
