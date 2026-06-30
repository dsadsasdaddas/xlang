module main

// cats [file] — squeeze consecutive blank lines into one (like `cat -s`).
// stdin if no file.
fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut prev_blank: bool = false
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            let line: String = str_slice(s, start, i)
            let mut is_blank: bool = false
            if str_len(line) == 0 {
                is_blank = true
            }
            if is_blank {
                if !prev_blank {
                    print_raw("\n")
                }
                prev_blank = true
            } else {
                print_raw(line)
                print_raw("\n")
                prev_blank = false
            }
            start = i + 1
        }
        i += 1
    }
    if start < n {
        let line: String = str_slice(s, start, n)
        let mut is_blank: bool = false
        if str_len(line) == 0 {
            is_blank = true
        }
        if is_blank {
            if !prev_blank {
                print_raw("\n")
            }
        } else {
            print_raw(line)
            print_raw("\n")
        }
    }
    return 0
}
