//# publish
module 0xCAFE::TestModule {
    // Function to test binding variables directly in patterns
    public fun pattern_binding_test(): bool {
        let (a, (b, c)) = (1, (2, 3));
        // Check if the pattern matching worked
        (a == 1) && (b == 2) && (c == 3)
    }

    // Function to test block expression evaluation order and side effects
    public fun block_eval_order_test(): u64 {
        let x = 0;
        let result = {
            x = x + 1;
            // Side effect: x is now 1
            x = x * 10;
            // Side effect: x is now 10
            x
        };
        // After the block, x should be 10 and result should be 10
        // We return result for inspection
        result
    }

    // Runner function to invoke the tests and return their results
    public fun run_tests(): (bool, u64) {
        let pattern_result = pattern_binding_test();
        let block_result = block_eval_order_test();
        (pattern_result, block_result)
    }
}

//# run 0xCAFE::TestModule::run_tests

// Featurres:
// b12c4b597314be2d929c4915dc02b906: Bind variables directly in patterns using standard pattern matching syntax
// 77a897b04432899df3b701e08fda0184: Test that block expressions used as arguments to a function are evaluated in left-to-right order and that their side effects on local variables are properly applied.
// 1150e97b1d14b0647b6fb152fce63fd7: Write expressions in Move programs
