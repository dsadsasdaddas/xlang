module main

// grep <pattern> <file> — print lines containing the pattern (like GNU grep).
// Splits the file into lines (by '\n' = 10) and uses str_find to match.
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: grep <pattern> <file>")
        return 1
    }
    let pat: String = argv(1)
    let s: String = read_file(argv(2))
    let n: i32 = str_len(s)
    let mut start: i32 = 0
    let mut i: i32 = 0
    let mut matched: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            let line: String = str_slice(s, start, i)
            if str_find(line, pat) >= 0 {
                print_raw(line)
                print_raw("\n")
                matched += 1
            }
            start = i + 1
        }
        i += 1
    }
    if start < n {
        let line: String = str_slice(s, start, n)
        if str_find(line, pat) >= 0 {
            print_raw(line)
            print_raw("\n")
            matched += 1
        }
    }
    return matched
}
