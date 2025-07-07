
//# publish
module 0xCAFE::ExprOrderLoopTest {
    use std::vector;

    // 1. Evaluation Order & Side Effects
    //
    // This function demonstrates that block expressions passed as arguments
    // are evaluated in left-to-right order, updating a shared local variable.
    public fun eval_order_test(): u8 {
        let x = 0u8;

        // Move does NOT support nested functions inside other functions.
        // Define sum as a separate function outside or inline here:
        // We'll define sum inline here as a simple operation.

        let sum = |a: u8, b: u8| -> u8 { a + b };

        // Evaluate blocks that mutably update x and return its value
        let res = sum(
            {
                x = x + 1u8;
                x
            },
            {
                x = x + 2u8;
                x
            },
        );

        // After arguments evaluated left-to-right:
        // First block adds 1 -> x=1
        // Second block adds 2 -> x=3
        // sum(1, 3) = 4
        // Return res + current x to verify cumulative effect (4 + 3 = 7)
        res + x
    }

    // sum moved outside the function as a helper
    public fun sum(a: u8, b: u8): u8 {
        a + b
    }

    // 2. For Loop Variable Declaration & Bounds
    //
    // Sum all integers from start (inclusive) to end (exclusive)
    public fun for_loop_test(start: u8, end: u8): u8 {
        let sum = 0u8;
        for (i in start..end) {
            sum = sum + i;
        };
        sum
    }

    // 3. Combined Feature Testing
    //
    // Use block expressions with side effects to compute loop bounds,
    // and accumulate sum in variable updated inside loop body.
    public fun combined_test(): u8 {
        let state = 0u8;

        // Block increments state by 1 and returns updated value -> lower bound
        let start = {
            state = state + 1u8;
            state  // 1 after this block
        };

        // Block increments state by 2 and returns value -> upper bound
        let end = {
            state = state + 2u8;
            state  // 3 after this block
        };

        let total = 0u8;
        for (i in start..end) {
            // inside loop, add i + current state to total,
            // then increment state by 1
            total = total + i + state;
            state = state + 1u8;
        };

        // Final total and state reflect cumulative side effects
        total + state
    }

    // 4. Test Case Collection

    // Return module metadata with name and address as vector<u8>
    public fun module_metadata(): vector<u8> {
        b"0xCAFE::ExprOrderLoopTest"
    }

    // Return vector of test case names as vector<vector<u8>>
    public fun collected_test_cases(): vector<vector<u8>> {
        vector[
            b"eval_order_test",
            b"for_loop_test",
            b"combined_test"
        ]
    }
}



//# run 0xCAFE::ExprOrderLoopTest::eval_order_test



//# run 0xCAFE::ExprOrderLoopTest::for_loop_test --args 1u8 5u8



//# run 0xCAFE::ExprOrderLoopTest::combined_test


// Features:
// 8ab2c2b88ea0c5733f361b383914e6f8: Test that blocks used as function arguments are evaluated in the correct left-to-right order, each block can mutate local variables, and the final result reflects these side effects.
// bce1addcf9180a073b026685fa13ba54: Declare a new loop variable that iterates from the lower bound (inclusive) up to the upper bound (exclusive) in a for loop.
// 5e329af1abb77b9ee8a0a89f9ac15e7f: Create a test plan with module address, name, and collected test cases for testing purposes.
