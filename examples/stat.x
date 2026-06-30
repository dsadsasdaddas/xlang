module main

// stat <path> — print file type and size (simplified GNU stat).
// Uses file_exists / is_dir / file_size (all existing builtins).
fn main(): i32 {
    if argc() < 2 {
        print_str("usage: stat <path>")
        return 1
    }
    let path: String = argv(1)
    if file_exists(path) {
        if is_dir(path) {
            print_raw(str_concat(path, ": directory\n"))
        } else {
            let size: i32 = file_size(path)
            print_raw(str_concat(str_concat(str_concat(path, ": file, "), int_to_str(size)), " bytes\n"))
        }
    } else {
        print_raw(str_concat(path, ": not found\n"))
        return 1
    }
    return 0
}
