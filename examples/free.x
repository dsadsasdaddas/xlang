module main

// free — show memory total and available (from /proc/meminfo).
fn extract_meminfo(m: String, key: String): i32 {
    let pos: i32 = str_find(m, key)
    if pos < 0 {
        return 0
    }
    let n: i32 = str_len(m)
    let mut i: i32 = pos + str_len(key)
    while i < n {
        let c: i32 = str_char_at(m, i)
        if c >= 48 {
            if c <= 57 {
                break
            }
        }
        i += 1
    }
    let mut val: i32 = 0
    while i < n {
        let c: i32 = str_char_at(m, i)
        if c < 48 {
            break
        }
        if c > 57 {
            break
        }
        val = val * 10 + (c - 48)
        i += 1
    }
    return val
}

fn main(): i32 {
    let m: String = read_file("/proc/meminfo")
    let total: i32 = extract_meminfo(m, "MemTotal:")
    let avail: i32 = extract_meminfo(m, "MemAvailable:")
    print_raw(str_concat("total: ", int_to_str(total)))
    print_raw(" kB  ")
    print_raw(str_concat("available: ", int_to_str(avail)))
    print_raw(" kB\n")
    return 0
}
