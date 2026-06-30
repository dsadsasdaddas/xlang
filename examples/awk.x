module main

// awk [-F sep] 'PROGRAM' [file] — minimal text processor.
// PROGRAM forms:
//   {print ...}            every line
//   PATTERN{print ...}     lines matching PATTERN
//   PATTERN                 lines matching PATTERN (default action: print $0)
// PATTERN: NR==N / NR!=N / NR<N / NR>N / NR<=N / NR>=N  (N a number)
// print items (comma-separated, space-joined): $0  $N  NR  NF  "literal"
// `print` alone prints $0. Field sep: whitespace (default) or -F char.

fn is_digit(c: i32): bool {
    if c < 48 { return false }
    if c > 57 { return false }
    return true
}

fn trim_s(s: String): String {
    let n: i32 = str_len(s)
    let mut a: i32 = 0
    while a < n {
        if str_char_at(s, a) == 32 { a = a + 1 } else { break }
    }
    let mut b: i32 = n
    while b > a {
        if str_char_at(s, b - 1) == 32 { b = b - 1 } else { break }
    }
    return str_slice(s, a, b)
}

fn split_on(s: String, sep: i32): Vec<String> {
    let v: Vec<String> = vec_new()
    let n: i32 = str_len(s)
    let mut start: i32 = 0
    let mut i: i32 = 0
    while i <= n {
        if i == n || str_char_at(s, i) == sep {
            v.push(str_slice(s, start, i))
            start = i + 1
        }
        i = i + 1
    }
    return v
}

fn split_fields(line: String, sep: i32): Vec<String> {
    let v: Vec<String> = vec_new()
    let n: i32 = str_len(line)
    let mut start: i32 = -1
    let mut i: i32 = 0
    while i < n {
        let c: i32 = str_char_at(line, i)
        let mut is_sep: bool = false
        if sep == 0 {
            is_sep = c == 32 || c == 9
        } else {
            is_sep = c == sep
        }
        if is_sep {
            if start >= 0 {
                v.push(str_slice(line, start, i))
                start = -1
            }
        } else {
            if start < 0 {
                start = i
            }
        }
        i = i + 1
    }
    if start >= 0 {
        v.push(str_slice(line, start, n))
    }
    return v
}

fn eval_item(item: String, line: String, fields: Vec<String>, lineno: i32, nf: i32): String {
    let it: String = trim_s(item)
    if str_eq(it, "$0") { return line }
    if str_eq(it, "NR") { return int_to_str(lineno) }
    if str_eq(it, "NF") { return int_to_str(nf) }
    if str_char_at(it, 0) == 36 {
        let idx: i32 = str_to_int(str_slice(it, 1, str_len(it)))
        if idx >= 1 {
            if idx <= nf { return fields[idx - 1] }
        }
        return ""
    }
    let il: i32 = str_len(it)
    if il >= 2 {
        if str_char_at(it, 0) == 34 && str_char_at(it, il - 1) == 34 {
            return str_slice(it, 1, il - 1)
        }
    }
    return it
}

fn parse_op(pattern: String): i32 {
    let p: i32 = str_find(pattern, "NR")
    let rest: String = str_slice(pattern, p + 2, str_len(pattern))
    let r0: i32 = str_char_at(rest, 0)
    let r1: i32 = str_char_at(rest, 1)
    if r0 == 61 { return 0 }
    if r0 == 33 { return 1 }
    if r0 == 60 {
        if r1 == 61 { return 2 }
        return 3
    }
    if r0 == 62 {
        if r1 == 61 { return 4 }
        return 5
    }
    return 0
}

fn parse_num(pattern: String): i32 {
    let p: i32 = str_find(pattern, "NR")
    let rest: String = trim_s(str_slice(pattern, p + 2, str_len(pattern)))
    let rn: i32 = str_len(rest)
    let mut i: i32 = 0
    while i < rn {
        let c: i32 = str_char_at(rest, i)
        if c == 61 || c == 33 || c == 60 || c == 62 {
            i = i + 1
        } else {
            break
        }
    }
    let mut sign: i32 = 1
    if i < rn {
        if str_char_at(rest, i) == 45 {
            sign = -1
            i = i + 1
        }
    }
    let mut val: i32 = 0
    while i < rn {
        if is_digit(str_char_at(rest, i)) {
            val = val * 10 + (str_char_at(rest, i) - 48)
            i = i + 1
        } else {
            break
        }
    }
    return val * sign
}

fn pattern_matches(op: i32, num: i32, lineno: i32): bool {
    if op == 0 { return lineno == num }
    if op == 1 { return lineno != num }
    if op == 2 { return lineno <= num }
    if op == 3 { return lineno < num }
    if op == 4 { return lineno >= num }
    if op == 5 { return lineno > num }
    return false
}

fn main(): i32 {
    let mut sep: i32 = 0
    let mut prog: String = ""
    let mut file: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_find(a, "-F") == 0 {
            sep = str_char_at(a, 2)
        } else {
            if str_len(prog) == 0 {
                prog = a
            } else {
                file = a
            }
        }
        i = i + 1
    }
    let pn: i32 = str_len(prog)
    let brace: i32 = str_find(prog, "{")
    let mut pattern: String = ""
    let mut action: String = "print"
    if brace >= 0 {
        pattern = trim_s(str_slice(prog, 0, brace))
        let close: i32 = str_find(prog, "}")
        action = trim_s(str_slice(prog, brace + 1, close))
    } else {
        pattern = trim_s(prog)
    }
    let mut items: Vec<String> = vec_new()
    if str_find(action, "print") == 0 {
        let rest: String = trim_s(str_slice(action, 5, str_len(action)))
        if str_len(rest) > 0 {
            items = split_on(rest, 44)
        }
    }
    let has_pattern: bool = str_len(pattern) > 0
    let mut op: i32 = 0
    if has_pattern {
        op = parse_op(pattern)
    }
    let mut num: i32 = 0
    if has_pattern {
        num = parse_num(pattern)
    }
    let mut s: String = ""
    if str_len(file) > 0 {
        s = read_file(file)
    } else {
        s = read_stdin()
    }
    let n: i32 = str_len(s)
    let mut lineno: i32 = 0
    let mut start: i32 = 0
    let mut p: i32 = 0
    while p <= n {
        let at_nl: bool = p < n && str_char_at(s, p) == 10
        let at_end: bool = p == n && start < n
        if !at_nl && !at_end {
            p = p + 1
            continue
        }
        lineno = lineno + 1
        let line: String = str_slice(s, start, p)
        if !has_pattern || pattern_matches(op, num, lineno) {
            let fields: Vec<String> = split_fields(line, sep)
            let nf: i32 = vec_len(fields)
            let ic: i32 = vec_len(items)
            if ic == 0 {
                print_raw(line)
                print_raw("\n")
            } else {
                let mut j: i32 = 0
                while j < ic {
                    if j > 0 {
                        print_raw(" ")
                    }
                    print_raw(eval_item(items[j], line, fields, lineno, nf))
                    j = j + 1
                }
                print_raw("\n")
            }
        }
        start = p + 1
        p = p + 1
    }
    return 0
}
