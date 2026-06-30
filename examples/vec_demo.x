module main

fn main(): i32 {
    let mut v: Vec<i32> = vec_new()
    let mut i: i32 = 0
    while i < 5 {
        v.push(i * i)
        i += 1
    }
    let mut sum: i32 = 0
    for n in v {
        sum += n
    }
    print_i32(sum)
    return sum
}
