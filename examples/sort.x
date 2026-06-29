module main

// sort [file] — sort lines (like GNU sort). Uses quicksort (O(n log n)) for
// competitive performance; the Vec is sorted in place via index assignment
// (the data pointer is shared across the value-copy).
fn quicksort(lines: Vec<String>, lo: i32, hi: i32) {
    if lo < hi {
        let pivot: String = lines[hi]
        let mut i: i32 = lo - 1
        let mut j: i32 = lo
        while j < hi {
            if str_cmp(lines[j], pivot) <= 0 {
                i += 1
                let tmp: String = lines[i]
                lines[i] = lines[j]
                lines[j] = tmp
            }
            j += 1
        }
        i += 1
        let tmp2: String = lines[i]
        lines[i] = lines[hi]
        lines[hi] = tmp2
        quicksort(lines, lo, i - 1)
        quicksort(lines, i + 1, hi)
    }
}

fn main(): i32 {
    let mut s: String = ""
    if argc() >= 2 {
        s = read_file(argv(1))
    } else {
        s = read_stdin()
    }
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
    let count: i32 = vec_len(lines)
    if count > 0 {
        quicksort(lines, 0, count - 1)
    }
    let mut k: i32 = 0
    while k < count {
        print_raw(lines[k])
        print_raw("\n")
        k += 1
    }
    return 0
}
