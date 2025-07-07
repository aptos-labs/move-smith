
//# publish
module 0xCAFE::LoopTests {
    use std::vector;

    // Function to test nested for loops with labels and control flow
    public fun test_nested_loops() {
        let sum = 0;
        'outer: for i in 0..3 {
            for j in 0..3 {
                if (i == 1 && j == 1) {
                    break 'outer;
                }
                sum = sum + i + j;
            };
        };
        // Expect sum to be 0+0+1+0+1+2+2+0+2+1+2+2 (break occurs at i=1, j=1)
        assert!(sum == 6, 1001);
    }

    // Function to test while loop and mod operation
    public fun test_while_and_mod() {
        let x = 10u64;
        let total = 0;
        while (x > 0) {
            total = total + (x % 3);
            x = x - 1;
        };
        assert!(total == 16, 1002);
    }

    // Test that overflow in constant expression causes abort
    public fun test_overflow_const() {
        // The following should abort at compile time, but for runtime testing, define a function that triggers overflow
        let _ = (u8::MAX + 1); // should abort at runtime
    }

    // Test division by zero
    public fun test_divide_zero() {
        let _ = 10u64 / 0u64; // should abort at runtime
    }

    // Test modulo by zero
    public fun test_mod_zero() {
        let _ = 10u64 % 0u64; // should abort at runtime
    }

    // Test explicit casting that causes out of range
    public fun test_cast_out_of_range() {
        let large_value = 300u16;
        // Casting u16::MAX (65535) to u8 should be invalid (out of range), expect abort
        let _ = large_value as u8; // should abort at runtime
    }
}


//# run 0xCAFE::LoopTests::test_nested_loops

//# run 0xCAFE::LoopTests::test_while_and_mod

//# run 0xCAFE::LoopTests::test_divide_zero

//# run 0xCAFE::LoopTests::test_mod_zero

//# run 0xCAFE::LoopTests::test_cast_out_of_range

// Featurres:
// f16ab6c7f5ad48b44b5a9821e95caea3: Create 'for' loops with the 'for' syntax and optional labels for iteration.
// c55db86185c0d0ecf3a554d5fe77b012: Test that nested loops and control flow (for and while) correctly update variables and reach specified assertions in a Move script.
// 3791ac15e9d738e5bd320f39ae9a7a6b: Test that constant expressions which would cause overflows, division/modulo by zero, or out-of-range type casts are not silently simplified away and correctly abort at runtime.
