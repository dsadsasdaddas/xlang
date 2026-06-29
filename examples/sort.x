module main

// sort [-r] [file] — sort lines lexicographically (or reverse with -r, like
// GNU sort / sort -r). Uses quicksort O(n log n). stdin if no file.
fn quicksort(lines: Vec<String>, lo: i32, hi: i32, reverse: bool): i32 {
    if lo < hi {
        let pivot: String = lines[hi]
        let mut i: i32 = lo - 1
        let mut j: i32 = lo
        while j < hi {
            let cmp: i32 = str_cmp(lines[j], pivot)
            let mut should_swap: bool = false
            if reverse {
                should_swap = cmp > 0
            } else {
                should_swap = cmp <= 0
            }
            if should_swap {
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
        quicksort(lines, lo, i - 1, reverse)
        quicksort(lines, i + 1, hi, reverse)
    }
    return 0
}

fn main(): i32 {
    let mut reverse: bool = false
    let mut s: String = ""
    if argc() >= 2 {
        if str_eq(argv(1), "-r") {
            reverse = true
            if argc() >= 3 {
                s = read_file(argv(2))
            } else {
                s = read_stdin()
            }
        } else {
            s = read_file(argv(1))
        }
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
        quicksort(lines, 0, count - 1, reverse)
    }
    let mut k: i32 = 0
    while k < count {
        print_raw(lines[k])
        print_raw("\n")
        k += 1
    }
    return 0
}
