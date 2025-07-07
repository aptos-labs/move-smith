
//# publish
module 0xCAFE::LoopControlTest {
    public fun run_continue_in_nested_if(account: &signer) {
        let numbers = vector[1, 2, 3, 4, 5];
        let sum = 0; // added mut to allow mutation

        let len = vector::length(&numbers);
        let i = 0; // changed to mut to allow modification

        while (i < len) {
            let current = *vector::borrow(&numbers, i);

            // Nested if statement to test continue
            if (current % 2 == 0) {
                if (current > 2) {
                    // Continue skips the remaining code and goes to next iteration
                    i = i + 1;
                    continue;
                }
            }

            sum = sum + current;
            i = i + 1;
        }

        // Verify that sum includes only odd numbers and even numbers <= 2
        // Expected sum is 1 + 2 + 3 + 5 = 11
        assert!(sum == 11);
    }

    #[verify_only]
    public fun verify_pattern_in_expression() acquires 0 {
        // This is a verification-only function to demonstrate patterns.
    }
}


//# run 0xCAFE::LoopControlTest::run_continue_in_nested_if --signers 0xCAFE