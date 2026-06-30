module main

// test -f <file> | -d <dir> | <file> — file existence/directory test (like
// GNU test -f/-d). Returns 0 (true) or 1 (false) via exit code.
fn main(): i32 {
    if argc() < 2 {
        return 1
    }
    if str_eq(argv(1), "-f") {
        if argc() >= 3 {
            if file_exists(argv(2)) {
                return 0
            }
        }
        return 1
    }
    if str_eq(argv(1), "-d") {
        if argc() >= 3 {
            if is_dir(argv(2)) {
                return 0
            }
        }
        return 1
    }
    if file_exists(argv(1)) {
        return 0
    }
    return 1
}
