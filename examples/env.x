module main

// env — list all environment variables (like GNU env). Uses env_count /
// env_entry to iterate the `environ` array.
fn main(): i32 {
    let n: i32 = env_count()
    let mut i: i32 = 0
    while i < n {
        print_raw(env_entry(i))
        print_raw("\n")
        i += 1
    }
    return 0
}
