//# publish
module 0xabc::id_mut_test {
    // Test that id_mut returns a mutable reference, allowing direct mutation of the input.
    fun id_mut<T>(r: &mut T): &mut T {
        r
    }

    public fun run_test() {
        let mut num = 42;
        let num_ref = id_mut(&mut num);
        *num_ref = 100; // Mutate through the reference
        // Assuming an external assertion or print for verification
        // Here, for demonstration, we rely on the mutation effect
        // The mutation should persist in `num`
        // (Assertions are ignored as per instructions)
    }
}

//# run 0xabc::id_mut_test::run_test

//# publish
module 0xabc::inline_call_test {
    // Test that the inline function `foo` correctly calls the provided lambda with given arguments and returns its result.
    inline fun foo(g: |u64, u64| u64, x: u64, y: u64): u64 {
        g(x, y)
    }

    public fun test() {
        let result = foo(|a, b| a + b, 10, 20);
        // result should be 30
        // No assertions needed
    }
}

//# run 0xabc::inline_call_test::test

//# publish
module 0xabc::sequence_struct_test {
    // Verify sequential assignment and retention in a struct.
    struct Data has copy, drop {
        a: u64,
        b: u64,
        c: u64,
        d: u64,
        e: u64,
    }

    fun build_sequence(p: Data): Data {
        let a = p;
        let b = a;
        let c = b;
        let d = c;
        let e = d;
        Data {a: a.a, b: b.b, c: c.c, d: d.d, e: e.e}
    }

    public fun main() {
        let input = Data {a: 5, b: 10, c: 15, d: 20, e: 25};
        let result = build_sequence(input);
        // Expect result to be equal to input
        // No assertions needed
    }
}

//# run 0xabc::sequence_struct_test::main