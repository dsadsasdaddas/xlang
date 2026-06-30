module main

// expand [file] — convert tabs to spaces (tab stop = 8, like GNU expand).
// stdin if no file.
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
    while i < n {
        let c: i32 = str_char_at(s, i)
        if c == 9 {
            let spaces: i32 = 8 - (col % 8)
            let mut j: i32 = 0
            while j < spaces {
                print_raw(" ")
                j += 1
            }
            col += spaces
        } else {
            print_raw(str_slice(s, i, i + 1))
            if c == 10 {
                col = 0
            } else {
                col += 1
            }
        }
        i += 1
    }
    return 0
}
