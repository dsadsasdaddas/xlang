module main

// uniq [-c] [-d] [file] — drop adjacent duplicate lines (GNU uniq).
// -c: prefix each line with its count. -d: only print duplicated lines.
fn emit(line: String, c: i32, want_c: bool, want_d: bool): i32 {
    if want_d {
        if c > 1 {
            print_raw(line)
            print_raw("\n")
        }
    } else {
        if want_c {
            print_raw(pad_int(c, 7))
            print_raw(" ")
            print_raw(line)
            print_raw("\n")
        } else {
            print_raw(line)
            print_raw("\n")
        }
    }
    return 0
}

fn main(): i32 {
    let mut want_c: bool = false
    let mut want_d: bool = false
    let mut file: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_char_at(a, 0) == 45 {
            let la: i32 = str_len(a)
            let mut k: i32 = 1
            while k < la {
                let c: i32 = str_char_at(a, k)
                if c == 99 { want_c = true }
                if c == 100 { want_d = true }
                k = k + 1
            }
        } else {
            file = a
        }
        i = i + 1
    }
    let mut s: String = ""
    if str_len(file) > 0 {
        s = read_file(file)
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut prev: String = ""
    let mut count: i32 = 0
    let mut have_run: bool = false
    let mut start: i32 = 0
    let mut k: i32 = 0
    while k < n {
        if str_char_at(s, k) == 10 {
            let line: String = str_slice(s, start, k)
            if !have_run {
                prev = line
                count = 1
                have_run = true
            } else {
                if str_eq(line, prev) {
                    count = count + 1
                } else {
                    emit(prev, count, want_c, want_d)
                    prev = line
                    count = 1
                }
            }
            start = k + 1
        }
        k = k + 1
    }
    if have_run {
        emit(prev, count, want_c, want_d)
    }
    return 0
}
