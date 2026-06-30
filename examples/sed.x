module main

// sed [-n] <script> [file] — stream editor. Supports:
//   s/old/new/[g]   substitute (literal old->new; g = all occurrences on line)
//   d               delete line (suppress its output)
//   p               print line (with -n, the way to emit a line)
//   N  /  N,M       address: apply only to line N / lines N..M
//   -n              suppress automatic printing
// Literal string matching (no regex). stdin if no file.
//   sed 's/a/X/g'         sed '2d'      sed -n '3p'      sed '1,2s/o/0/'

fn is_digit(c: i32): bool {
    if c < 48 { return false }
    if c > 57 { return false }
    return true
}

fn matches_at(line: String, at: i32, pat: String): bool {
    let ln: i32 = str_len(line)
    let pn: i32 = str_len(pat)
    if pn == 0 { return false }
    if at + pn > ln { return false }
    let mut j: i32 = 0
    while j < pn {
        if str_char_at(line, at + j) != str_char_at(pat, j) { return false }
        j = j + 1
    }
    return true
}

fn substitute(line: String, pat: String, repl: String, global: bool): String {
    let ln: i32 = str_len(line)
    let pn: i32 = str_len(pat)
    if pn == 0 { return line }
    sb_new()
    let mut i: i32 = 0
    let mut did_one: bool = false
    while i < ln {
        let take: bool = (!did_one || global) && matches_at(line, i, pat)
        if take {
            sb_push(repl)
            i = i + pn
            did_one = true
        } else {
            sb_push_char(str_char_at(line, i))
            i = i + 1
        }
    }
    return sb_str()
}

fn main(): i32 {
    let mut suppress: bool = false
    let mut script: String = ""
    let mut file: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_eq(a, "-n") {
            suppress = true
        } else {
            if str_eq(a, "-e") {
                i = i + 1
                if i < argc() {
                    script = argv(i)
                }
            } else {
                if str_len(script) == 0 {
                    script = a
                } else {
                    file = a
                }
            }
        }
        i = i + 1
    }
    let sn: i32 = str_len(script)
    let mut pos: i32 = 0
    let mut addr_lo: i32 = 0
    let mut addr_hi: i32 = 0
    let mut have_addr: bool = false
    if pos < sn {
        if is_digit(str_char_at(script, pos)) {
            have_addr = true
            while pos < sn {
                if is_digit(str_char_at(script, pos)) {
                    addr_lo = addr_lo * 10 + (str_char_at(script, pos) - 48)
                    pos = pos + 1
                } else {
                    break
                }
            }
            addr_hi = addr_lo
            if pos < sn {
                if str_char_at(script, pos) == 44 {
                    pos = pos + 1
                    addr_hi = 0
                    while pos < sn {
                        if is_digit(str_char_at(script, pos)) {
                            addr_hi = addr_hi * 10 + (str_char_at(script, pos) - 48)
                            pos = pos + 1
                        } else {
                            break
                        }
                    }
                }
            }
        }
    }
    let cmd: i32 = str_char_at(script, pos)
    let mut sep: i32 = 47
    let mut pat: String = ""
    let mut repl: String = ""
    let mut global: bool = false
    if cmd == 115 {
        sep = str_char_at(script, pos + 1)
        let mut j: i32 = pos + 2
        let pat_start: i32 = j
        while j < sn {
            if str_char_at(script, j) == sep { break }
            j = j + 1
        }
        pat = str_slice(script, pat_start, j)
        let repl_start: i32 = j + 1
        let mut k2: i32 = repl_start
        while k2 < sn {
            if str_char_at(script, k2) == sep { break }
            k2 = k2 + 1
        }
        repl = str_slice(script, repl_start, k2)
        if k2 + 1 < sn {
            if str_char_at(script, k2 + 1) == 103 {
                global = true
            }
        }
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
            let in_range: bool = !have_addr || (lineno >= addr_lo && lineno <= addr_hi)
            let mut out: String = line
            let mut deleted: bool = false
            let mut explicit_print: bool = false
            if in_range {
                if cmd == 115 {
                    out = substitute(line, pat, repl, global)
                }
                if cmd == 100 {
                    deleted = true
                }
                if cmd == 112 {
                    explicit_print = true
                }
            }
            if explicit_print {
                print_raw(out)
                print_raw("\n")
            }
            if !deleted && !suppress {
                print_raw(out)
                print_raw("\n")
            }
            start = p + 1
        p = p + 1
    }
    return 0
}
