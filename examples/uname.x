module main

// uname — print "sysname release" (like `uname -sr`). Reads /proc/sys/kernel.
fn strip_nl(s: String): String {
    let n: i32 = str_len(s)
    let mut e: i32 = n
    if n > 0 {
        if str_char_at(s, n - 1) == 10 {
            e = n - 1
        }
    }
    return str_slice(s, 0, e)
}

fn main(): i32 {
    let sysname: String = strip_nl(read_file("/proc/sys/kernel/ostype"))
    let release: String = strip_nl(read_file("/proc/sys/kernel/osrelease"))
    print_raw(str_concat(str_concat(sysname, " "), release))
    print_raw("\n")
    return 0
}
