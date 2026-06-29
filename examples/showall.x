module main

// showall [file] — display all characters including tabs (^I) and line ends ($).
// Like GNU `cat -A`. stdin if no file.
fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut i: i32 = 0
    while i < n {
        let c: i32 = str_char_at(s, i)
        if c == 9 {
            print_raw("^I")
        } else {
            if c == 10 {
                print_raw("$\n")
            } else {
                print_raw(str_slice(s, i, i + 1))
            }
        }
        i += 1
    }
    return 0
}
