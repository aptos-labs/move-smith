//# publish
module 0xA1B2::num_literal_tests {
    // Test that numeric literals are treated as u64 and do not overflow within bounds
    public fun test_literals() {
        // These are within u64 bounds
        let a = 42;
        let b = 1000;
        let c = 9999999999;
    }

    // Test that calculations stay within u64 bounds
    public fun test_multiplication() {
        let val1 = 2;
        let val2 = 32;
        let product = val1 * val2; // 64, within u64
    }

    // Placeholder function to check that max u64 value doesn't overflow
    public fun test_max_u64() {
        let max = 18446744073709551615; // u64::MAX
        // Should not overflow
        let doubled = max; // No operation here; just to keep max
    }
}

//# run 0xA1B2::num_literal_tests::test_literals
//# run 0xA1B2::num_literal_tests::test_multiplication
//# run 0xA1B2::num_literal_tests::test_max_u64

//# publish
module 0xA1B2::overflow_test {
    public fun test_overflow() {
        // Intentionally exceed u64 max, should fail compilation or runtime
        // Here, we generate a value > u64::MAX
        // The test script will attempt to assign this literal
        // and expect a failure.
        let overflow_value = 18446744073709551616; // u64::MAX + 1
    }

    public fun run_overflow_test() {
        // Function to be called in the script, to attempt overflow
        // but actual overflow will happen at literal assignment time,
        // so no runtime code needed.
    }
}

//# run 0xA1B2::overflow_test::test_overflow

//# publish
module 0xC3D4::loop_bound_tests {
    public fun bounds_within() {
        let a = 1;
        let b = 1;
        let max_iterations = 64;
        while (b < max_iterations) {
            a = 2 * a;
            b = b + 1;
        }
    }

    public fun near_limit() {
        let i = 1;
        let j = 1;
        // Loop runs exactly 63 times to stay within u64
        while (j < 63) {
            i = 2 * i;
            j = j + 1;
        }
    }

    public fun exceeding_limit() {
        let x = 1;
        let y = 1;
        // Loop intended to go beyond u64 bounds - will overflow if unchecked
        // but in script, this should fail or cause an overflow error
        while (y < 65) {
            // Potential overflow at 2 * x when exceeding u64 max
            x = 2 * x;
            y = y + 1;
        }
    }
}

//# run 0xC3D4::loop_bound_tests::bounds_within
//# run 0xC3D4::loop_bound_tests::near_limit
//# run 0xC3D4::loop_bound_tests::exceeding_limit

//# publish
module 0x42::recursive_fibonacci {
    public fun fib(n: u64): u64 {
        if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        } else {
            return fib(n - 1) + fib(n - 2);
        }
    }

    public fun test_fibonacci_numbers() {
        assert!(fib(0) == 0, 0);
        assert!(fib(1) == 1, 1);
        assert!(fib(2) == 1, 2);
        assert!(fib(3) == 2, 3);
        assert!(fib(4) == 3, 4);
        assert!(fib(5) == 5, 5);
        assert!(fib(6) == 8, 6);
        assert!(fib(7) == 13, 7);
        assert!(fib(8) == 21, 8);
        assert!(fib(9) == 34, 9);
        assert!(fib(10) == 55, 10);
    }
}

//# run 0x42::recursive_fibonacci::test_fibonacci_numbers