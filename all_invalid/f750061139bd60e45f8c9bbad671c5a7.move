module 0xCAFE::LoopAndArithmeticTest {
    use std::vector;

    // Function to test iterating over an empty range (start > end)
    public fun test_empty_range(): bool {
        let sum = 0u64;
        let start: u64 = 10;
        let end: u64 = 5; // start > end, loop should not execute
        let i = start;
        while (i < end) {
            // The loop body is skipped since start > end
            sum = sum + i;
            i = i + 1;
        };
        // Expect sum to be 0 if loop body is skipped
        sum == 0
    }

    // Functions to test u16 arithmetic, including overflow detection
    public fun test_u16_add(a: u16, b: u16): bool {
        let sum = a + b;
        // For non-overflowed sum, check correctness
        sum == (a as u32 + b as u32) as u16
    }

    public fun test_u16_sub(a: u16, b: u16): bool {
        if b > a {
            // Subtraction would underflow - in Move, wraparound occurs
            let result = a - b; // should wrap around
            // Verify wrapping: result == (a as u32).wrapping_sub(b as u32) as u16
            result == ((a as u32).wrapping_sub(b as u32) as u16)
        } else {
            let result = a - b;
            result == (a as u32 - b as u32) as u16
        }
    }

    public fun test_u16_mul(a: u16, b: u16): bool {
        let result = a * b;
        // Check that multiplication is correct under non-overflowing conditions
        result == (a as u32 * b as u32) as u16
    }

    public fun test_u16_div(a: u16, b: u16): bool {
        if b == 0 {
            // Division by zero should panic, here we simulate detection
            abort 9999; // Use an abort to represent error
        } else {
            let result = a / b;
            result == (a as u32 / b as u32) as u16
        }
    }

    public fun test_u16_mod(a: u16, b: u16): bool {
        if b == 0 {
            abort 9998; // simulate division by zero
        } else {
            let result = a % b;
            result == (a as u32 % b as u32) as u16
        }
    }

    // Function to test inline function with multiple closures accepting different patterns
    public fun run_closures_with_patterns(): bool {
        // Lambda with two arguments with different names
        let lambda1: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + 1, b + 2)
        };
        // Invoke lambda1
        let (x1, y1) = lambda1(5u8, 10u8);

        // Lambda with different argument pattern
        let lambda2: |u16| u16 = |z: u16| {
            z * 2
        };
        let result = lambda2(7u16);

        // Inline lambda with nested pattern
        let lambda3: |u8, u8| (u8, u8) has copy+drop = |m: u8, n: u8| {
            (m - 1, n - 1)
        };
        let (x2, y2) = lambda3(20u8, 30u8);

        // Return true if all invocations produce expected results
        // For demonstration, we don't do assertions here, just ensure invocation works
        if (x1 == 6 && y1 == 12 && result == 14 && x2 == 19 && y2 == 29) {
            true
        } else {
            false
        }
    }

    // Runner function to execute all tests
    public fun run_all_tests(): bool {
        // Test 1: Empty loop
        let empty_range_test = test_empty_range();

        // Test 2: u16 arithmetic tests
        let add_test = test_u16_add(65535, 1); // expect wraparound or check
        let sub_test = test_u16_sub(10, 20); // underflow check
        let mul_test = test_u16_mul(300u16, 200u16);
        let div_test_valid = test_u16_div(100u16, 4u16);
        // For division by zero, simulate abort handled above
        let div_test_zero = abort_if_false(test_u16_div(10u16, 0u16));

        let mod_test_valid = test_u16_mod(10u16, 3u16);
        // For modulus with zero
        let mod_test_zero = abort_if_false(test_u16_mod(10u16, 0u16));

        // Test 3: Invoke closure patterns
        let closure_pattern_test = run_closures_with_patterns();

        empty_range_test && add_test && sub_test && mul_test && div_test_valid && div_test_zero && mod_test_valid && mod_test_zero && closure_pattern_test
    }

    // Helper to abort if false
    fun abort_if_false(cond: bool): bool {
        if (!cond) {
            abort 8888;
        }
        cond
    }
}



//# run 0xCAFE::LoopAndArithmeticTest::run_all_tests