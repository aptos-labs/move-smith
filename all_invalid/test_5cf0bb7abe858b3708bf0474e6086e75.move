//# publish
module 0xabcde::factorial {
    // Computes factorial of a given number n
    public fun factorial(n: u64): u64 {
        let result = 1;
        let i = 1;
        while (i <= n) {
            result = result * i;
            i = i + 1;
        };
        result
    }

    // Computes the factorial of 0, used for testing edge case
    public fun test_zero_factorial() {
        assert!(factorial(0) == 1, 0);
    }

    // Computes the factorial of 1, a trivial case
    public fun test_one_factorial() {
        assert!(factorial(1) == 1, 1);
    }

    // Tests for larger values
    public fun test_large_factorial() {
        assert!(factorial(5) == 120, 2);
        assert!(factorial(10) == 3628800, 3);
    }

    // Fourth test to verify sequential multiplication correctness for mid-range
    public fun test_medium_factorial() {
        assert!(factorial(7) == 5040, 4);
    }
}

//# run 0xabcde::factorial::test_zero_factorial
//# run 0xabcde::factorial::test_one_factorial
//# run 0xabcde::factorial::test_large_factorial
//# run 0xabcde::factorial::test_medium_factorial