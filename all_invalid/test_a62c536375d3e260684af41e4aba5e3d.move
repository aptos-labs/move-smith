//# publish
module 0xA11E::captured_test {
    // A struct to test capturing a composite object
    struct Pair has copy, drop {
        first: u64,
        second: String,
    }

    // Function that captures a primitive and a struct
    public fun primitive_and_struct_capture(x: u64, s: String): u64 {
        let captured_x = x;
        let captured_s = s;
        let f = |additional: u64| {
            captured_x + additional + (string::length(&captured_s) as u64)
        };
        f(5)
    }

    // Function that captures a struct with nested fields
    public fun nested_struct_capture(p: Pair): u64 {
        let f = |delta: u64| {
            p.first + delta + (string::length(&p.second) as u64)
        };
        f(10)
    }

    // Function that captures multiple variables
    public fun multiple_captures(a: u64, b: u64, s: String): u64 {
        let cap_a = a;
        let cap_b = b;
        let cap_s = s;
        let f = |x: u64| {
            cap_a + cap_b + x + (string::length(&cap_s) as u64)
        };
        f(7)
    }

    // Function that captures a struct with a nested function inside
    public fun struct_with_inner_fn(s: Pair): u64 {
        let inner_fn = |offset: u64| {
            s.first * offset + (string::length(&s.second) as u64)
        };
        inner_fn(3)
    }
}

//# run 0xA11E::captured_test::primitive_and_struct_capture --args 10 "hello"
// Expected: 10 + 5 + length("hello") == 10 + 5 + 5 = 20

//# run 0xA11E::captured_test::nested_struct_capture --args 8  --signers 0x1 --args 0x2: Pair { first: 15, second: "world" }
// Expected: 15 + 10 + length("world") == 15 + 10 + 5 = 30

//# run 0xA11E::captured_test::multiple_captures --args 3 4 "move"
// Expected: 3 + 4 + 7 + length("move") == 3 + 4 + 7 + 4 = 18

//# run 0xA11E::captured_test::struct_with_inner_fn --args 7 --signers 0x1 --args 0x2: Pair { first: 6, second: "test" }
// Expected: 6 * 7 + length("test") == 42 + 4 = 46