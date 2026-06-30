module main

// cut -d<delim> -f<fields> [file]   OR   cut -c<range> [file]
// -f: comma field list (1 or 2,3). -c: char range (2 or 1-3). GNU-compatible.
fn main(): i32 {
    let mut delim_s: String = "\t"
    let fields: Vec<i32> = vec_new()
    let mut char_mode: bool = false
    let mut cstart: i32 = 0
    let mut cend: i32 = 0
    let mut file: String = ""
    let mut i: i32 = 1
    while i < argc() {
        let a: String = argv(i)
        if str_char_at(a, 0) == 45 {
            let c1: i32 = str_char_at(a, 1)
            if c1 == 100 {
                if str_len(a) > 2 {
                    delim_s = str_slice(a, 2, 3)
                } else {
                    i = i + 1
                    delim_s = str_slice(argv(i), 0, 1)
                }
            }
            if c1 == 102 {
                let mut spec: String = ""
                if str_len(a) > 2 {
                    spec = str_slice(a, 2, str_len(a))
                } else {
                    i = i + 1
                    spec = argv(i)
                }
                let sn: i32 = str_len(spec)
                let mut st: i32 = 0
                let mut k: i32 = 0
                while k <= sn {
                    if k == sn || str_char_at(spec, k) == 44 {
                        if k > st {
                            fields.push(str_to_int(str_slice(spec, st, k)))
                        }
                        st = k + 1
                    }
                    k = k + 1
                }
            }
            if c1 == 99 {
                char_mode = true
                let mut spec: String = ""
                if str_len(a) > 2 {
                    spec = str_slice(a, 2, str_len(a))
                } else {
                    i = i + 1
                    spec = argv(i)
                }
                let sn: i32 = str_len(spec)
                let mut dash: i32 = -1
                let mut k: i32 = 0
                while k < sn {
                    if str_char_at(spec, k) == 45 {
                        dash = k
                    }
                    k = k + 1
                }
                if dash < 0 {
                    cstart = str_to_int(spec)
                    cend = cstart
                } else {
                    cstart = str_to_int(str_slice(spec, 0, dash))
                    cend = str_to_int(str_slice(spec, dash + 1, sn))
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
    let mut lstart: i32 = 0
    let mut p: i32 = 0
    while p <= n {
        if p == n || str_char_at(s, p) == 10 {
            let line: String = str_slice(s, lstart, p)
            let ln: i32 = str_len(line)
            if char_mode {
                let mut a: i32 = cstart - 1
                if a < 0 {
                    a = 0
                }
                let mut b: i32 = cend
                if b > ln {
                    b = ln
                }
                if a < b {
                    print_raw(str_slice(line, a, b))
                }
                print_raw("\n")
            } else {
                let delim: i32 = str_char_at(delim_s, 0)
                let fcount: i32 = vec_len(fields)
                let out: Vec<String> = vec_new()
                let mut fstart: i32 = 0
                let mut cur: i32 = 1
                let mut q: i32 = 0
                while q <= ln {
                    if q == ln || str_char_at(line, q) == delim {
                        let mut fi: i32 = 0
                        while fi < fcount {
                            if fields[fi] == cur {
                                out.push(str_slice(line, fstart, q))
                            }
                            fi = fi + 1
                        }
                        cur = cur + 1
                        fstart = q + 1
                    }
                    q = q + 1
                }
                let oc: i32 = vec_len(out)
                let mut oi: i32 = 0
                while oi < oc {
                    if oi > 0 {
                        print_raw(delim_s)
                    }
                    print_raw(out[oi])
                    oi = oi + 1
                }
                print_raw("\n")
            }
            lstart = p + 1
        }
        p = p + 1
    }
    return 0
}
