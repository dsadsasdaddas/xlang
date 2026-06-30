module main

// sort [-r] [-n] [file] — sort lines lexicographically (default), numeric (-n),
// and/or reverse (-r). GNU-compatible flags.
// Bottom-up merge sort: O(n log n) guaranteed, STABLE (matches GNU — equal keys
// keep input order), and iterative (no recursion → no stack overflow).

fn cmp3(a: String, b: String, numeric: bool): i32 {
    if numeric {
        let va: i32 = str_to_int(a)
        let vb: i32 = str_to_int(b)
        if va < vb {
            return -1
        }
        if va > vb {
            return 1
        }
        return 0
    }
    let c: i32 = str_cmp(a, b)
    if c < 0 {
        return -1
    }
    if c > 0 {
        return 1
    }
    return 0
}

fn merge_sort(lines: Vec<String>, tmp: Vec<String>, count: i32, reverse: bool, numeric: bool): i32 {
    let mut width: i32 = 1
    while width < count {
        let mut i: i32 = 0
        while i < count {
            let lo: i32 = i
            let mut mid: i32 = i + width
            if mid > count {
                mid = count
            }
            let mut hi: i32 = i + 2 * width
            if hi > count {
                hi = count
            }
            let mut a: i32 = lo
            let mut b: i32 = mid
            let mut t: i32 = lo
            while a < mid {
                if b < hi {
                    let c: i32 = cmp3(lines[a], lines[b], numeric)
                    let mut take_a: bool = false
                    if reverse {
                        if c >= 0 {
                            take_a = true
                        }
                    } else {
                        if c <= 0 {
                            take_a = true
                        }
                    }
                    if take_a {
                        tmp[t] = lines[a]
                        a = a + 1
                    } else {
                        tmp[t] = lines[b]
                        b = b + 1
                    }
                    t = t + 1
                } else {
                    tmp[t] = lines[a]
                    a = a + 1
                    t = t + 1
                }
            }
            while b < hi {
                tmp[t] = lines[b]
                b = b + 1
                t = t + 1
            }
            i = i + 2 * width
        }
        let mut c2: i32 = 0
        while c2 < count {
            lines[c2] = tmp[c2]
            c2 = c2 + 1
        }
        width = width * 2
    }
    return 0
}

fn main(): i32 {
    let mut reverse: bool = false
    let mut numeric: bool = false
    let mut file: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_char_at(a, 0) == 45 {
            let la: i32 = str_len(a)
            let mut k: i32 = 1
            while k < la {
                let c: i32 = str_char_at(a, k)
                if c == 114 {
                    reverse = true
                }
                if c == 110 {
                    numeric = true
                }
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
    let lines: Vec<String> = vec_new()
    let n: i32 = str_len(s)
    let mut start: i32 = 0
    let mut k: i32 = 0
    while k < n {
        if str_char_at(s, k) == 10 {
            lines.push(str_slice(s, start, k))
            start = k + 1
        }
        k = k + 1
    }
    if start < n {
        lines.push(str_slice(s, start, n))
    }
    let count: i32 = vec_len(lines)
    if count > 0 {
        let tmp: Vec<String> = vec_new()
        let mut z: i32 = 0
        while z < count {
            tmp.push("")
            z = z + 1
        }
        merge_sort(lines, tmp, count, reverse, numeric)
    }
    let mut j: i32 = 0
    while j < count {
        print_raw(lines[j])
        print_raw("\n")
        j = j + 1
    }
    return 0
}
