
//# publish
module 0xCAFE::LoopTests {
    use std::vector;

    // Function to test nested loops with labels and control flow
    public fun test_nested_loops() {
        let sum = 0;
        let outer_break = false;
        // Since Move currently doesn't support labeled loops, simulate label break with a boolean flag
        let outer: &mut bool = &mut outer_break;

        for i in 0..3 {
            if (*outer) { break; }
            for j in 0..3 {
                if (i == 1 && j == 1) {
                    *outer = true; // simulate breaking outer loop
                    break;
                }
                sum = sum + i + j;
            }
        }
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
        // The following should abort at runtime
        let _ = (u8::MAX + 1); // should abort
    }

    // Test division by zero
    public fun test_divide_zero() {
        let _ = 10u64 / 0u64; // should abort
    }

    // Test modulo by zero
    public fun test_mod_zero() {
        let _ = 10u64 % 0u64; // should abort
    }

    // Test explicit casting that causes out of range
    public fun test_cast_out_of_range() {
        let large_value = 300u16;
        // Casting u16::MAX (65535) to u8 should cause abort
        let _ = large_value as u8; // should abort
    }
}


//# run 0xCAFE::LoopTests::test_nested_loops

//# run 0xCAFE::LoopTests::test_while_and_mod

//# run 0xCAFE::LoopTests::test_divide_zero

//# run 0xCAFE::LoopTests::test_mod_zero

//# run 0xCAFE::LoopTests::test_cast_out_of_range