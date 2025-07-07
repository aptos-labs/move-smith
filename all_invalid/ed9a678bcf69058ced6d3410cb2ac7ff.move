// Transactional test for Move compiler/VM covering:
// 1. Lifted lambda expressions added as functions in global env.
// 2. Variables unchanged when conditional skipped, assertions detecting initial `x`.
// 3. Nested if-continue inside outer loop breaking when condition false.

module 0x1::TestNestedControl {

    use std::debug;
    use std::vector;

    /// 1. Lifted lambda expressions -> simulate this by defining a global pure function,
    /// which acts like a lifted lambda.

    /// A simple "lambda" that adds 10 to its argument.
    public fun add_ten(x: u64): u64 {
        x + 10
    }

    /// 2. Function to test variables unchanged and assertion correctness.
    public fun test_variables_unchanged() acquires {
        let mut x = 42u64;

        // Conditional that is false, so block skipped, x unchanged.
        if (false) {
            x = 100;
        };

        // Assert that x is still 42.
        debug::assert!(x == 42, 0);

        // Additionally, call the lifted lambda function to verify return value.
        let res = add_ten(x);
        debug::assert!(res == 52, 1);
    }

    /// 3. Test nested if-continue inside an outer loop.
    /// Loop from 0 to 9, continue if inner if true, break if outer if false.
    public fun test_nested_if_continue_and_break() acquires {
        let mut i = 0;
        let mut sum = 0u64;

        // Outer loop label: not needed syntactically in Move, but logical.
        while (true) {
            // If i >= 10, break the loop.
            if (i >= 10) {
                break;
            }

            // If i is even, continue the loop to skip adding to sum.
            if ((i % 2) == 0) {
                i = i + 1;
                continue;
            }

            // Add odd numbers to sum
            sum = sum + i;

            i = i + 1;
        }

        // After loop, sum should be sum of odd numbers < 10: 1+3+5+7+9 = 25
        debug::assert!(sum == 25, 2);
    }

    #[test_only]
    public fun transactional_test() acquires {
        test_variables_unchanged();
        test_nested_if_continue_and_break();
    }
}

// Featurres:
// 1866c40bc2f20f6142313ef44b66c3f3: Add lifted lambda expressions into the global environment as functions.
// cff3dd41dce0fdf717f0f7fe905177e7: Verify that the Move script correctly leaves variables unchanged and that the assertion properly detects the initial value of `x` when the conditional block is skipped.
// 312e4630fd94dea2ace81bdc0229c624: Test that nested if-continue statements correctly interact with an outer loop, allowing the loop to break when the condition is false.
