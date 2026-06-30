module main

// sha256sum [file] — print SHA-256 hash (like GNU sha256sum).
// Format: "<64-hex-hash>  <filename>" (or "  -" for stdin).

fn main(): i32 {
    let mut file: String = ""
    if argc() >= 2 {
        file = argv(1)
    }
    let mut s: String = ""
    if str_len(file) > 0 {
        s = read_file(file)
    } else {
        s = read_stdin()
    }
    print_raw(sha256_hex(s))
    print_raw("  ")
    if str_len(file) > 0 {
        print_raw(file)
    } else {
        print_raw("-")
    }
    print_raw("\n")
    return 0
}
