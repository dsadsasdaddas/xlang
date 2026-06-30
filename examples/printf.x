module main

// printf FORMAT [args...] — formatted output (like GNU printf).
// Specifiers: %s (string) %d (decimal) %x (hex) %c (char) %% (literal %)
// Escapes: \n \t \r \\
// Cycles FORMAT through all args (bash behavior).

fn int_to_hex(v: i32): String {
    if v == 0 {
        return "0"
    }
    let digits: String = "0123456789abcdef"
    let mut val: i32 = v
    let mut result: String = ""
    while val > 0 {
        let d: i32 = val & 15
        result = str_concat(str_slice(digits, d, d + 1), result)
        val = val >> 4
    }
    return result
}

fn count_spec(fmt: String): i32 {
    let n: i32 = str_len(fmt)
    let mut count: i32 = 0
    let mut i: i32 = 0
    while i < n {
        if str_char_at(fmt, i) == 37 {
            if i + 1 < n {
                let c: i32 = str_char_at(fmt, i + 1)
                if c == 115 || c == 100 || c == 120 || c == 99 {
                    count = count + 1
                }
            }
        }
        i = i + 1
    }
    return count
}

fn print_pass(fmt: String, arg_idx: i32): i32 {
    let n: i32 = str_len(fmt)
    let mut i: i32 = 0
    let mut ai: i32 = arg_idx
    sb_new()
    while i < n {
        let c: i32 = str_char_at(fmt, i)
        if c == 92 {
            if i + 1 < n {
                let e: i32 = str_char_at(fmt, i + 1)
                if e == 110 {
                    sb_push_char(10)
                } else {
                    if e == 116 {
                        sb_push_char(9)
                    } else {
                        if e == 114 {
                            sb_push_char(13)
                        } else {
                            sb_push_char(e)
                        }
                    }
                }
                i = i + 2
            } else {
                sb_push_char(92)
                i = i + 1
            }
        } else {
            if c == 37 {
                if i + 1 < n {
                    let s: i32 = str_char_at(fmt, i + 1)
                    if s == 115 {
                        if ai < argc() {
                            sb_push(argv(ai))
                            ai = ai + 1
                        }
                        i = i + 2
                    } else {
                        if s == 100 {
                            let mut val: i32 = 0
                            if ai < argc() {
                                val = str_to_int(argv(ai))
                                ai = ai + 1
                            }
                            sb_push(int_to_str(val))
                            i = i + 2
                        } else {
                            if s == 120 {
                                let mut val: i32 = 0
                                if ai < argc() {
                                    val = str_to_int(argv(ai))
                                    ai = ai + 1
                                }
                                sb_push(int_to_hex(val))
                                i = i + 2
                            } else {
                                if s == 99 {
                                    if ai < argc() {
                                        sb_push_char(str_char_at(argv(ai), 0))
                                        ai = ai + 1
                                    }
                                    i = i + 2
                                } else {
                                    if s == 37 {
                                        sb_push_char(37)
                                        i = i + 2
                                    } else {
                                        sb_push_char(37)
                                        i = i + 1
                                    }
                                }
                            }
                        }
                    }
                } else {
                    sb_push_char(37)
                    i = i + 1
                }
            } else {
                sb_push_char(c)
                i = i + 1
            }
        }
    }
    print_raw(sb_str())
    return ai
}

fn main(): i32 {
    if argc() < 2 {
        return 0
    }
    let fmt: String = argv(1)
    let sc: i32 = count_spec(fmt)
    if sc == 0 {
        print_pass(fmt, argc())
        return 0
    }
    let mut ai: i32 = 2
    while true {
        let prev: i32 = ai
        ai = print_pass(fmt, ai)
        if ai >= argc() {
            break
        }
        if ai == prev {
            break
        }
    }
    return 0
}
