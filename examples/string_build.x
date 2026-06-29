module main

fn main(): i32 {
    let greeting: String = str_concat("Hello, ", "xlang!")
    print_str(greeting)
    let n: i32 = str_len(greeting)
    print_i32(n)
    let num: String = int_to_str(42)
    let combined: String = str_concat("answer = ", num)
    print_str(combined)
    return 0
}
