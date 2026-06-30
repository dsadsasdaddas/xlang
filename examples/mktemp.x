module main

// mktemp — create a temporary file with a unique name (like GNU mktemp).

fn main(): i32 {
    random_seed()
    let pid: i32 = getpid()
    let rnd: i32 = random_int(999999)
    let mut name: String = "/tmp/xlang_tmp_"
    name = str_concat(name, int_to_str(pid))
    name = str_concat(name, "_")
    name = str_concat(name, int_to_str(rnd))
    write_file(name, "")
    print_raw(name)
    print_raw("\n")
    return 0
}
