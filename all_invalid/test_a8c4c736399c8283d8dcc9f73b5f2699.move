//# publish
module 0x1::assert_and_loop_tests {
    use std::assert;

    // Runner function to test assert! macro with various conditions and errors
    public fun run_assert_tests() {
        // Call individual test functions
        assert_true_no_abort();
        assert_false_abort();
        assert_with_division_by_zero(); // Expected to abort
    }

    // Test case: assertion true, no abort
    fun assert_true_no_abort() {
        // Should not abort
        assert!(true, 1 / 0);
    }

    // Test case: assertion false, triggers abort with runtime error
    fun assert_false_abort() {
        // Should abort due to assertion false, even if expression is 1 / 0 (runtime error)
        assert!(false, 1 / 0);
    }

    // Test case: assertion true with runtime error expression (deprecated, but included for coverage)
    fun assert_with_runtime_error() {
        // Will trigger abort due to true condition, but expression involves division by zero
        assert!(true, 1 / 0);
    }

    // A function with a loop that contains an early return, to test loop termination
    public fun test_loop_with_return() {
        let mut counter = 0;
        loop {
            if (counter >= 3) {
                return;
            }
            if (counter == 1) {
                return;
            }
            counter = counter + 1;
        }
        // Should terminate when counter == 1
    }
}

//# run
script {
    fun main() {
        0x1::assert_and_loop_tests::run_assert_tests();
        0x1::assert_and_loop_tests::test_loop_with_return();
    }
}

//# run 0x1::assert_and_loop_tests::run_assert_tests --signers 0x1