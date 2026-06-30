module main

// base64 — encode stdin to base64 (like GNU base64). Uses sb_push for O(n)
// string building (avoids the O(n²) str_concat trap).
fn main(): i32 {
    let s: String = read_stdin()
    let n: i32 = str_len(s)
    let table: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    let mut i: i32 = 0
    sb_new()
    while i < n {
        let b0: i32 = str_char_at(s, i)
        let mut b1: i32 = 0
        let mut b2: i32 = 0
        let have1: bool = i + 1 < n
        let have2: bool = i + 2 < n
        if have1 {
            b1 = str_char_at(s, i + 1)
        }
        if have2 {
            b2 = str_char_at(s, i + 2)
        }
        let idx0: i32 = b0 >> 2
        let idx1: i32 = ((b0 & 3) << 4) | (b1 >> 4)
        let idx2: i32 = ((b1 & 15) << 2) | (b2 >> 6)
        let idx3: i32 = b2 & 63
        sb_push(str_slice(table, idx0, idx0 + 1))
        sb_push(str_slice(table, idx1, idx1 + 1))
        if have1 {
            sb_push(str_slice(table, idx2, idx2 + 1))
        } else {
            sb_push("=")
        }
        if have2 {
            sb_push(str_slice(table, idx3, idx3 + 1))
        } else {
            sb_push("=")
        }
        i += 3
    }
    print_raw(sb_str())
    print_raw("\n")
    return 0
}
