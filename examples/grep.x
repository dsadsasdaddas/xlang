module main

// grep [-v] <pattern> [file] — print lines matching (or NOT matching with -v)
// the pattern. Like GNU grep (substring) / grep -v. stdin if no file.
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: grep [-v] <pattern> [file]")
        return 1
    }
    let mut pat: String = ""
    let mut invert: bool = false
    let mut file_idx: i32 = 0
    if str_eq(argv(1), "-v") {
        if argc() < 3 {
            print_str("usage: grep -v <pattern> [file]")
            return 1
        }
        invert = true
        pat = argv(2)
        if argc() >= 4 {
            file_idx = 3
        }
    } else {
        pat = argv(1)
        if argc() >= 3 {
            file_idx = 2
        }
    }
    let mut s: String = ""
    if file_idx > 0 {
        s = read_file(argv(file_idx))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut start: i32 = 0
    let mut i: i32 = 0
    let mut matched: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            let line: String = str_slice(s, start, i)
            let found: bool = str_find(line, pat) >= 0
            if found != invert {
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
        let found: bool = str_find(line, pat) >= 0
        if found != invert {
            print_raw(line)
            print_raw("\n")
            matched += 1
        }
    }
    return matched
}
