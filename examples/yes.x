module main

// yes [string] — print a string repeatedly forever (like GNU yes). Default "y".
// Pipe through head to stop: yes | head -3
fn main(): i32 {
    let mut msg: String = "y"
    if argc() >= 2 {
        msg = argv(1)
    }
    while true {
        print_raw(msg)
        print_raw("\n")
    }
    return 0
}
