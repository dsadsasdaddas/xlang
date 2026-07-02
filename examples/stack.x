module main

// stack — a classic data structure: a struct holding a Vec<i32>, with
// push/pop/peek methods. Exercises struct-with-Vec-field (which now compiles
// correctly) + impl methods + range loop + assert.
// Run: xlangc run examples/stack.x

struct Stack {
    data: Vec<i32>
}

impl Stack {
    fn push(self: Stack, v: i32): i32 {
        self.data.push(v)
        return 0
    }
    fn peek(self: Stack): i32 {
        let n: i32 = vec_len(self.data)
        if n == 0 { return -1 }
        return self.data[n - 1]
    }
    fn sum(self: Stack): i32 {
        let mut total: i32 = 0
        for v in self.data {
            total += v
        }
        return total
    }
}

fn main(): i32 {
    let mut buf: Vec<i32> = vec_new()
    let s: Stack = Stack { data: buf }
    s.push(10)
    s.push(20)
    s.push(30)
    print_i32(s.peek())   // 30
    print_i32(s.sum())    // 60
    assert(s.peek() == 30)
    assert(s.sum() == 60)
    return 0
}
