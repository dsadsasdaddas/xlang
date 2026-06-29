module main

// chmod <octal-mode> <file> — change file permissions (like GNU chmod 755 file).
// Uses str_to_int_oct to parse the octal mode string.
fn main(): i32 {
    if argc() < 3 {
        print_str("usage: chmod <octal-mode> <file>")
        return 1
    }
    return chmod(argv(2), str_to_int_oct(argv(1)))
}
