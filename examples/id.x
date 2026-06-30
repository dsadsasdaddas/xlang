module main

// id — print user identity (simplified GNU id).
// Prints: uid=PID(whoami) gid=PID(whoami)

fn main(): i32 {
    let user: String = getenv("USER")
    let pid: i32 = getpid()
    print_raw("uid=")
    print_raw(int_to_str(pid))
    print_raw("(")
    print_raw(user)
    print_raw(") gid=")
    print_raw(int_to_str(pid))
    print_raw("(")
    print_raw(user)
    print_raw(")")
    print_raw("\n")
    return 0
}
