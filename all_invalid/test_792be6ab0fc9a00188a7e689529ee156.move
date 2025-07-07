//# publish
module 0x1::test_module {
    // Function to simulate early return in a script
    public fun early_return_test(): bool {
        if (true) {
            return true;
        }
        false
    }

    // Function to test range iteration
    public fun sum_range(): u64 {
        let mut sum = 0;
        for (i in 0..10) {
            sum = sum + i;
        }
        sum
    }

    // Cyclic function for testing value preservation
    public fun cyclic_input(p: u64): u64 {
        let temp = p;
        let temp2 = temp;
        p = temp2;
        p
    }

    // Runner function combining all tests
    public fun run_all_tests(): () {
        // Run early return test
        let early_result = early_return_test();
        // Run sum range test
        let total_sum = sum_range();
        // Run cyclic test with a sample value
        let cyclic_value = cyclic_input(99);
        // For demonstration, these variables can be returned or used; in tests, assertions are optional
        // but here we'll just set them to global or ignore for simplicity
        assert!(early_result, 1);
        assert!(total_sum == 45, 2);
        assert!(cyclic_value == 99, 3);
    }
}

//# run 0x1::test_module::run_all_tests