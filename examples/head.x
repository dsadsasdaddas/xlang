module main

// head [file] — first 10 lines (like GNU head). Reads stdin if no file.
fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let limit: i32 = 10
    let mut printed: i32 = 0
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            print_raw(str_slice(s, start, i))
            print_raw("\n")
            printed += 1
            start = i + 1
            if printed >= limit {
                return 0
            }
        }
        i += 1
    }
    if start < n {
        if printed < limit {
            print_raw(str_slice(s, start, n))
            print_raw("\n")
        }
    }
    return 0
}
