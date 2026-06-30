module main

// groups [user] — print group names (simplified: just prints whoami).
fn main(): i32 {
    let user: String = whoami()
    print_raw(user)
    print_raw(" : ")
    print_raw(user)
    print_raw("\n")
    return 0
}
