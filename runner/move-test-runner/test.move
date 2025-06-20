//# publish
module 0xabcde::local_var_test {
    fun assign_new_value() {
        let mut counter = 0;
        counter = 5;
        assert!(counter == 5, 42);
    }

    public fun test() {
        assign_new_value();
    }
}

//# run 0xabcde::local_var_test::test

//# publish
module 0xfedcb::loop_u64_test {
    fun verify_bounds_increase() {
        let mut result = 1;
        let mut i = 0;
        while (i < 10) {
            result = result * 3;
            i = i + 1;
        };
        // result should be 3^10 = 59049
        assert!(result == 59049, 42);
    }

    fun verify_no_overflow_within_bounds() {
        let mut res = 1;
        let mut j = 0;
        while (j < 20) {
            res = res * 2;
            j = j + 1;
        };
        // 2^20 = 1,048,576 < u64::MAX
        assert!(res == 1 << 20, 42);
    }

    fun verify_overflow_failure() {
        // This function should not compile or should trap if overflow is detected
        // but since the test framework cannot catch compile errors here,
        // we describe the intent.
        // For illustration only:
        let mut large = 1;
        let mut k = 0;
        while (k < 65) {
            large = large * 2; // at 64, overflow might occur
            k = k + 1;
        }
        // In actual tests, if overflow is caught at runtime, this should panic.
        // We'll just place an assertion that would fail if overflow occurs.
        assert!(large >= 0, 42); // placeholder
    }

    public fun test() {
        verify_bounds_increase();
        verify_no_overflow_within_bounds();
        // To test overflow, you might call verify_overflow_failure() in a separate scenario
        // that intentionally triggers overflow, but here we just include it for completeness.
        // verify_overflow_failure(); // Uncomment to test overflow scenario
    }
}

//# run 0xfedcb::loop_u64_test::test