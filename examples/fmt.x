module main

// fmt [-w WIDTH] [file] — reformat text paragraphs to WIDTH columns.
// Default width 75. Blank lines separate paragraphs (preserved).
// Greedy line fill: accumulate words until adding one would exceed WIDTH.

fn reflow_paragraph(s: String, width: i32): i32 {
    let n: i32 = str_len(s)
    let mut i: i32 = 0
    let mut line: String = ""
    let mut line_len: i32 = 0
    sb_new()
    while i < n {
        let c: i32 = str_char_at(s, i)
        if c == 32 || c == 9 || c == 10 {
            i = i + 1
        } else {
            let wstart: i32 = i
            while i < n {
                let cc: i32 = str_char_at(s, i)
                if cc == 32 || cc == 9 || cc == 10 {
                    break
                }
                i = i + 1
            }
            let word: String = str_slice(s, wstart, i)
            let wlen: i32 = str_len(word)
            if line_len > 0 {
                if line_len + 1 + wlen > width {
                    sb_push(line)
                    sb_push_char(10)
                    line = word
                    line_len = wlen
                } else {
                    line = str_concat(str_concat(line, " "), word)
                    line_len = line_len + 1 + wlen
                }
            } else {
                line = word
                line_len = wlen
            }
        }
    }
    if line_len > 0 {
        sb_push(line)
        sb_push_char(10)
    }
    print_raw(sb_str())
    return 0
}

fn main(): i32 {
    let mut width: i32 = 75
    let mut file: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_find(a, "-w") == 0 {
            if str_len(a) > 2 {
                width = str_to_int(str_slice(a, 2, str_len(a)))
            } else {
                i = i + 1
                if i < argc() {
                    width = str_to_int(argv(i))
                }
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
    let n: i32 = str_len(s)
    let mut para: String = ""
    let mut k: i32 = 0
    let mut start: i32 = 0
    while k <= n {
        let at_nl: bool = k < n && str_char_at(s, k) == 10
        let at_end: bool = k == n && start < n
        if !at_nl && !at_end {
            k = k + 1
            continue
        }
        let line: String = str_slice(s, start, k)
        let ln: i32 = str_len(line)
        let mut blank: bool = true
        let mut j: i32 = 0
        while j < ln {
            let cc: i32 = str_char_at(line, j)
            if cc != 32 && cc != 9 {
                blank = false
            }
            j = j + 1
        }
        if blank {
            if str_len(para) > 0 {
                reflow_paragraph(para, width)
                para = ""
            }
            print_raw("\n")
        } else {
            if str_len(para) > 0 {
                para = str_concat(para, " ")
            }
            para = str_concat(para, line)
        }
        start = k + 1
        k = k + 1
    }
    if str_len(para) > 0 {
        reflow_paragraph(para, width)
    }
    return 0
}
