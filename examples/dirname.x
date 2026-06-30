module main

// dirname <path> — strip last component, keep directory (like GNU dirname).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: dirname <path>")
        return 1
    }
    let path: String = argv(1)
    let n: i32 = str_len(path)
    let mut last_slash: i32 = -1
    let mut i: i32 = 0
    while i < n {
        if str_char_at(path, i) == 47 {
            last_slash = i
        }
        i += 1
    }
    if last_slash <= 0 {
        print_raw(".")
    } else {
        print_raw(str_slice(path, 0, last_slash))
    }
    print_raw("\n")
    return 0
}
