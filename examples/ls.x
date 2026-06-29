module main

// ls [path] — list directory entries (like GNU ls, one per line). Defaults to
// ".". Uses dir_count / dir_entry (the readdir builtins added so xlang can do
// directory I/O).
fn main(): i32 {
    let mut path: String = "."
    if argc() >= 2 {
        path = argv(1)
    }
    let n: i32 = dir_count(path)
    let mut i: i32 = 0
    while i < n {
        print_raw(dir_entry(path, i))
        print_raw("\n")
        i += 1
    }
    return 0
}
