module main

// sort [-r] [-n] [file] — sort lines lexicographically (default), numeric (-n),
// and/or reverse (-r). GNU-compatible flags. Quicksort O(n log n).
fn less(a: String, b: String, numeric: bool): i32 {
    if numeric {
        let va: i32 = str_to_int(a)
        let vb: i32 = str_to_int(b)
        if va < vb {
            return 1
        }
        return 0
    }
    if str_cmp(a, b) < 0 {
        return 1
    }
    return 0
}

fn quicksort(lines: Vec<String>, lo: i32, hi: i32, reverse: bool, numeric: bool): i32 {
    if lo < hi {
        let span: i32 = hi - lo + 1
        let pidx: i32 = lo + random_int(span)
        let ptmp: String = lines[pidx]
        lines[pidx] = lines[hi]
        lines[hi] = ptmp
        let pivot: String = lines[hi]
        let mut i: i32 = lo - 1
        let mut j: i32 = lo
        while j < hi {
            let mut should_swap: bool = false
            if reverse {
                should_swap = less(lines[j], pivot, numeric) == 0
            } else {
                should_swap = less(lines[j], pivot, numeric) == 1
            }
            if should_swap {
                i = i + 1
                let tmp: String = lines[i]
                lines[i] = lines[j]
                lines[j] = tmp
            }
            j = j + 1
        }
        i = i + 1
        let tmp2: String = lines[i]
        lines[i] = lines[hi]
        lines[hi] = tmp2
        quicksort(lines, lo, i - 1, reverse, numeric)
        quicksort(lines, i + 1, hi, reverse, numeric)
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
        random_seed()
        quicksort(lines, 0, count - 1, reverse, numeric)
    }
    let mut j: i32 = 0
    while j < count {
        print_raw(lines[j])
        print_raw("\n")
        j = j + 1
    }
    return 0
}
