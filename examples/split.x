module main

// split <file> <lines> — split a file into N-line chunks (like GNU split -l).
// Writes chunks to xsplit_0, xsplit_1, etc.
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: split <file> <lines-per-chunk>")
        return 1
    }
    let s: String = read_file(argv(1))
    let lpc: i32 = str_to_int(argv(2))
    let n: i32 = str_len(s)
    let mut fnum: i32 = 0
    let mut lc: i32 = 0
    let mut chunk: String = ""
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            chunk = str_concat(chunk, str_slice(s, start, i + 1))
            lc += 1
            start = i + 1
            if lc >= lpc {
                write_file(str_concat("xsplit_", int_to_str(fnum)), chunk)
                fnum += 1
                lc = 0
                chunk = ""
            }
        }
        i += 1
    }
    if start < n {
        chunk = str_concat(chunk, str_slice(s, start, n))
        lc += 1
    }
    if lc > 0 {
        write_file(str_concat("xsplit_", int_to_str(fnum)), chunk)
        fnum += 1
    }
    print_i32(fnum)
    print_raw(" files written\n")
    return 0
}
