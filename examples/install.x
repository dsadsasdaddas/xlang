module main

// install [-m MODE] SRC DST — copy SRC to DST (like GNU install, simplified).
// Creates DST if needed. -m sets file mode (e.g., 755).

fn main(): i32 {
    let mut mode: String = ""
    let mut src: String = ""
    let mut dst: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_find(a, "-m") == 0 {
            if str_len(a) > 2 {
                mode = str_slice(a, 2, str_len(a))
            } else {
                i = i + 1
                if i < argc() {
                    mode = argv(i)
                }
            }
        } else {
            if str_len(src) == 0 {
                src = a
            } else {
                dst = a
            }
        }
        i = i + 1
    }
    if str_len(src) == 0 {
        print_str("usage: install [-m MODE] SRC DST")
        print_raw("\n")
        return 1
    }
    if str_len(dst) == 0 {
        dst = src
        src = ""
        if argc() < 2 {
            return 1
        }
    }
    if file_exists(src) {
        let body: String = read_file(src)
        write_file(dst, body)
        if str_len(mode) > 0 {
            let m: i32 = str_to_int(mode)
            chmod(dst, m)
        }
    } else {
        print_str("install: cannot stat '")
        print_raw(src)
        print_str("'")
        print_raw("\n")
        return 1
    }
    return 0
}
