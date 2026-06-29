module main

// wc [file] — count lines and characters (subset of GNU wc). stdin if no file.
fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut chars: i32 = 0
    let mut lines: i32 = 0
    let mut i: i32 = 0
    while i < n {
        let c: i32 = str_char_at(s, i)
        chars += 1
        if c == 10 {
            lines += 1
        }
        i += 1
    }
    print_i32(lines)
    print_raw(" lines\n")
    print_i32(chars)
    print_raw(" chars\n")
    return 0
}
