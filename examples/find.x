module main

// find [dir] [pattern] — recursively list files whose name contains pattern
// (like `find dir -name "*pattern*"`). No pattern = list all files.
// Uses is_dir (stat) to decide whether to recurse into subdirectories.
fn find_dir(dir: String, pat: String): i32 {
    let n: i32 = dir_count(dir)
    let mut i: i32 = 0
    let mut count: i32 = 0
    while i < n {
        let entry: String = dir_entry(dir, i)
        if !str_eq(entry, ".") {
            if !str_eq(entry, "..") {
                let path: String = str_concat(str_concat(dir, "/"), entry)
                if is_dir(path) {
                    count += find_dir(path, pat)
                }
                if str_find(entry, pat) >= 0 {
                    print_raw(path)
                    print_raw("\n")
                    count += 1
                }
            }
        }
        i += 1
    }
    return count
}

fn main(): i32 {
    let mut dir: String = "."
    let mut pat: String = ""
    if argc() >= 2 {
        dir = argv(1)
    }
    if argc() >= 3 {
        pat = argv(2)
    }
    return find_dir(dir, pat)
}
