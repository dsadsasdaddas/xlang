module main

// sort [-r] [-n] [file] — sort lines lexicographically (default), numeric (-n),
// and/or reverse (-r). GNU-compatible flags.
// Three-way (Dutch-flag) quicksort with random pivot: handles runs of equal
// elements in O(n) (avoids O(n²) on sorted input AND stack overflow on
// all-equal input like non-numeric text under -n).

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

fn quicksort(lines: Vec<String>, lo: i32, hi: i32, reverse: bool, numeric: bool): i32 {
    if lo >= hi {
        return 0
    }
    let pidx: i32 = lo + random_int(hi - lo + 1)
    let pivot: String = lines[pidx]
    let mut lt: i32 = lo
    let mut gt: i32 = hi
    let mut i: i32 = lo
    while i <= gt {
        let mut c: i32 = cmp3(lines[i], pivot, numeric)
        if reverse {
            c = 0 - c
        }
        if c < 0 {
            let t: String = lines[lt]
            lines[lt] = lines[i]
            lines[i] = t
            lt = lt + 1
            i = i + 1
        } else {
            if c > 0 {
                let t: String = lines[i]
                lines[i] = lines[gt]
                lines[gt] = t
                gt = gt - 1
            } else {
                i = i + 1
            }
        }
    }
    quicksort(lines, lo, lt - 1, reverse, numeric)
    quicksort(lines, gt + 1, hi, reverse, numeric)
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
