module main

// tail [N] [file] — last N lines (default 10, like GNU tail -n N). stdin if
// no file. N detected by first-char-is-digit.
fn main(): i32 {
    let mut limit: i32 = 10
    let mut file_idx: i32 = 0
    if argc() >= 2 {
        let first: i32 = str_char_at(argv(1), 0)
        if first >= 48 {
            if first <= 57 {
                limit = str_to_int(argv(1))
                if argc() >= 3 {
                    file_idx = 2
                }
            } else {
                file_idx = 1
            }
        } else {
            file_idx = 1
        }
    }
    let mut s: String = ""
    if file_idx > 0 {
        s = read_file(argv(file_idx))
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
    let mut k: i32 = 0
    if count > limit {
        k = count - limit
    }
    while k < count {
        print_raw(lines[k])
        print_raw("\n")
        k += 1
    }
    return 0
}
