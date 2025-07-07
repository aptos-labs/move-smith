//# publish
module 0xc0ffee::m {
    // Function to perform a basic swap of two u32 values
    fun swap_basic(x: u32, y: u32): (u32, u32) {
        (x, y) = (y, x);
        (x, y)
    }

    // Function to swap and modify values within a struct
    struct S {
        value: u64,
    }

    fun swap_struct(s1: S, s2: S): (S, S) {
        (s1, s2) = (s2, s1);
        (s1, s2)
    }

    // Function to demonstrate swapping within a loop
    fun swap_loop(x: u64, y: u64, n: u64): (u64, u64) {
        let mut x_mut = x;
        let mut y_mut = y;
        let mut i = 0;
        while (i < n) {
            (x_mut, y_mut) = (y_mut, x_mut);
            i = i + 1;
        }
        (x_mut, y_mut)
    }

    // Function to swap values via references
    fun swap_refs(x: &mut u64, y: &mut u64) {
        let temp = *x;
        *x = *y;
        *y = temp;
    }

    // Function to showcase variable shadowing during swaps
    fun swap_shadowing(x: u64, y: u64): (u64, u64) {
        let x = x + 1; // shadowing x
        let y = y + 2; // shadowing y
        (x, y)
    }

    // Function to perform a chained swap inside a nested scope
    fun swap_nested(a: u64, b: u64): (u64, u64) {
        let (a, b) = (b, a);
        // Shadowed variables here
        let a = a + 10;
        let b = b + 20;
        (a, b)
    }

    // Test functions
    public fun test_basic(): (u32, u32) {
        swap_basic(5, 10)
    }

    public fun test_struct(): (S, S) {
        swap_struct(S { value: 100 }, S { value: 200 })
    }

    public fun test_loop(): (u64, u64) {
        swap_loop(1, 2, 3)
    }

    public fun test_refs(): (u64, u64) {
        let mut a = 15;
        let mut b = 30;
        swap_refs(&mut a, &mut b);
        (a, b)
    }

    public fun test_shadowing(): (u64, u64) {
        swap_shadowing(7, 14)
    }

    public fun test_nested(): (u64, u64) {
        swap_nested(3, 6)
    }
}
//# run 0xc0ffee::m::test_basic
//# run 0xc0ffee::m::test_struct
//# run 0xc0ffee::m::test_loop
//# run 0xc0ffee::m::test_refs
//# run 0xc0ffee::m::test_shadowing
//# run 0xc0ffee::m::test_nested