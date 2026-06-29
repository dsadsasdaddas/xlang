module main

struct Student {
    name: String
    score: i32
}

fn top_student(students: Array<Student, 3>): Student {
    let mut best: i32 = 0
    let mut i: i32 = 1
    while i < 3 {
        if students[i].score > students[best].score {
            best = i
        }
        i += 1
    }
    return students[best]
}

fn main(): i32 {
    let class: Array<Student, 3> = [
        Student { name: "Alice", score: 88 },
        Student { name: "Bob", score: 95 },
        Student { name: "Carol", score: 91 },
    ]
    let top: Student = top_student(class)
    print_str(top.name)
    print_i32(top.score)
    return 0
}
