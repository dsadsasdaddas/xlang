module main

// tac [file] — print lines in reverse order (like GNU tac). stdin if no file.
fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let lines: Vec<String> = vec_new()
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            lines.push(str_slice(s, start, i))
            start = i + 1
        }
        i += 1
    }
    if start < n {
        lines.push(str_slice(s, start, n))
    }
    let count: i32 = vec_len(lines)
    let mut k: i32 = count - 1
    while k >= 0 {
        print_raw(lines[k])
        print_raw("\n")
        k -= 1
    }
    return 0
}
