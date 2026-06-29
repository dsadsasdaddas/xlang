module main

// comm <file1> <file2> — compare two sorted files line by line (like GNU comm).
// Column 1: lines only in file1. Column 2: only in file2. Column 3: in both.
fn split_lines(s: String): Vec<String> {
    let lines: Vec<String> = vec_new()
    let n: i32 = str_len(s)
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if str_char_at(s, i) == 10 {
            lines.push(str_slice(s, start, i))
            start = i + 1
        }
        i += 1
    }
    if start < n {
        lines.push(str_slice(s, start, n))
    }
    return lines
}

fn main(): i32 {
    if argc() < 3 {
        print_str("usage: comm <file1> <file2>")
        return 1
    }
    let a: Vec<String> = split_lines(read_file(argv(1)))
    let b: Vec<String> = split_lines(read_file(argv(2)))
    let an: i32 = vec_len(a)
    let bn: i32 = vec_len(b)
    let mut i: i32 = 0
    let mut j: i32 = 0
    while i < an || j < bn {
        if i >= an {
            print_raw("\t")
            print_raw(b[j])
            print_raw("\n")
            j += 1
        } else {
            if j >= bn {
                print_raw(a[i])
                print_raw("\n")
                i += 1
            } else {
                let cmp: i32 = str_cmp(a[i], b[j])
                if cmp < 0 {
                    print_raw(a[i])
                    print_raw("\n")
                    i += 1
                } else {
                    if cmp > 0 {
                        print_raw("\t")
                        print_raw(b[j])
                        print_raw("\n")
                        j += 1
                    } else {
                        print_raw("\t\t")
                        print_raw(a[i])
                        print_raw("\n")
                        i += 1
                        j += 1
                    }
                }
            }
        }
    }
    return 0
}
