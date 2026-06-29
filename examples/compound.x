module main

fn main(): i32 {
    let mut sum: i32 = 0
    let mut i: i32 = 0
    while i < 5 {
        sum += i
        i += 1
    }
    let mut product: i32 = 1
    product *= 7
    return sum + product
}
