
//# publish
module 0xCAFE::LoopControlTest {
    public fun run_continue_in_nested_if(account: &signer) {
        let numbers = vector[1, 2, 3, 4, 5];
        let sum = 0;

        let len = vector::length(&numbers);
        let i = 0;

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
        // sum should be 1 + 2 + 3 + 4 + 5 = 1 + 2 + 3 + 4 + 5 = 15,
        // but due to continue skipping 4 (even > 2), only 1, 2, 3, 5 are summed, total = 1 + 2 + 3 + 5 = 11
        // So, the expected sum is 11.
        assert!(sum == 11);
    }

    #[verify_only]
    public fun verify_pattern_in_expression() acquires 0 {
        // This is a verification-only function to demonstrate patterns.
    }
}


//# run 0xCAFE::LoopControlTest::run_continue_in_nested_if --signers 0xCAFE

// Featurres:
// 8b468e8ff48cba488f36e636d8850cc4: Test that the continue statement correctly skips to the next iteration of a loop within nested if statements.
// efe6f0219832d041cc27de82eac89a11: Define patterns to specify which parts of the expression the rule applies to, separated by commas.
// c7b5560c242cdd6b01699cc61c97f34e: Annotate code with the 'verify_only' attribute to specify verification-only functions or modules.
