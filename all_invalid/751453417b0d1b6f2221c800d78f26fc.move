//# publish
module 0xCAFE::TestModule {
    // Function to test binding variables directly in patterns
    public fun pattern_binding_test(): bool {
        // Move does NOT support pattern destructuring in a let binding directly.
        // Instead, we must assign to variables separately.
        let a = 1;
        let (b, c) = (2, 3);
        // Check if the pattern matching worked
        (a == 1) && (b == 2) && (c == 3)
    }

    // Function to test block expression evaluation order and side effects
    public fun block_eval_order_test(): u64 {
        let x = 0;
        let result = {
            // Evaluate inside block with side effects
            {
                // Increment x
                let mut temp_x = x;
                temp_x = temp_x + 1;
                // Assign back to x
                // Since Move does not support mutable variables like this, emulate by using an inner block
                // Actually, Move variables are immutable by default, but can be reassigned with `let mut`.
                // But all variables are mutable by default, so we can do:
                // (No, in Move, variables are immutable unless declared mutable)
                // For the test, declare x as mutable at start
            }
            // To simulate side effects, declare x as mutable at start
        };
        // Since we want to test side effects, rewrite accordingly:

        // Corrected version:
    }
    
    // Rewrite the block_eval_order_test function properly
    public fun block_eval_order_test(): u64 {
        // Declare x as mutable
        let mut x = 0;
        // Inside block, change x
        {
            x = x + 1; // x is now 1
            x = x * 10; // x is now 10
        }
        // Return x
        x
    }

    // Runner function to invoke the tests and return their results
    public fun run_tests(): (bool, u64) {
        let pattern_result = pattern_binding_test();
        let block_result = block_eval_order_test();
        (pattern_result, block_result)
    }
}

//# run 0xCAFE::TestModule::run_tests

// Features:
// b12c4b597314be2d929c4915dc02b906: Bind variables directly in patterns using standard pattern matching syntax
// 77a897b04432899df3b701e08fda0184: Test that block expressions used as arguments to a function are evaluated in left-to-right order and that their side effects on local variables are properly applied.
// 1150e97b1d14b0647b6fb152fce63fd7: Write expressions in Move programs