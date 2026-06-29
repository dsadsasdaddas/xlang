module main

// unexpand [file] — convert runs of spaces at tab stops to tabs (like
// `unexpand -a`). Complement of expand. stdin if no file.
fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut i: i32 = 0
    let mut col: i32 = 0
    let mut spaces: i32 = 0
    while i < n {
        let c: i32 = str_char_at(s, i)
        if c == 32 {
            spaces += 1
            col += 1
            if col % 8 == 0 {
                if spaces > 0 {
                    print_raw("\t")
                    spaces = 0
                }
            }
        } else {
            let mut j: i32 = 0
            while j < spaces {
                print_raw(" ")
                j += 1
            }
            spaces = 0
            print_raw(str_slice(s, i, i + 1))
            if c == 10 {
                col = 0
            } else {
                col += 1
            }
        }
        i += 1
    }
    let mut j: i32 = 0
    while j < spaces {
        print_raw(" ")
        j += 1
    }
    return 0
}
