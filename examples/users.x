module main

// users — print users currently logged in (simplified: just whoami).
fn main(): i32 {
    let user: String = getenv("USER")
    print_raw(user)
    print_raw("\n")
    return 0
}
