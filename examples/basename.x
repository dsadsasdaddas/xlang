module main

// basename <path> — strip directory, keep filename (like GNU basename).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: basename <path>")
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
    let base: String = str_slice(path, last_slash + 1, n)
    print_raw(base)
    print_raw("\n")
    return 0
}
