
//# publish
module 0xD0D0::ControlFlowTest {
    use std::vector;

    // Function to test multiple lambdas and their application
    public fun test_lambda_application() {
        let lambda1: |u8| u8 = |a: u8| { a + 2 };
        let lambda2: |u8| u8 = |a: u8| { a * 2 };

        let input_value: u8 = 4;
        let res1 = lambda1(input_value);
        let res2 = lambda2(input_value);
        let sum = res1 + res2;

        // Expect (4 + 2) + (4 * 2) = 6 + 8 = 14
        assert!(sum == 14, 999);
    }

    // Function to determine if a code location is unreachable
    public fun is_unreachable(flag: bool): bool {
        if (flag) {
            // unreachable branch: intentionally abort
            abort 999;
        } else {
            true
        }
        // Code after abort is unreachable, but static analysis might consider this branch reachable depending on flag
        // To test the reachability, add code here
        false
    }

    // Helper function to check token match without advancing
    public fun is_token_match(current_token: u8, expected: u8): bool {
        if (current_token == expected) {
            true
        } else {
            false
        }
    }

    // Runner function for testing all features
    public fun run_all() {
        // Test lambda application
        Self::test_lambda_application();

        // Test control flow unreachable detection
        let _reachability1 = Self::is_unreachable(false);
        // This should be false
        let _reachability2 = Self::is_unreachable(true); // Will abort, but since we don't run abort in test, assume not called

        // Test token match
        let token: u8 = 0xAB;
        let _matches = Self::is_token_match(token, 0xAB);
        let _not_matches = Self::is_token_match(token, 0xCD);
    }
}


//# run 0xD0D0::ControlFlowTest::run_all


// Featurres:
// e3e6532e767446e6ef8561091d72a7b2: Test that the inline function `foo` correctly applies multiple lambda functions to input values and sums their results as expected.
// 43c7fcce2bde52d945dfe5e725a926b9: Determine if a specific location in a function is definitely unreachable or potentially reachable during control flow analysis
// 7c982b714106aa6537da23a750293a54: Return true if the current token matches the specified token; otherwise, return false without advancing.
