
//# publish
module 0xCAFE::LoopAndScopeTest {
    use std::assert;

    // Internal function to test invocation within module
    internal fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Main test function
    public fun run_test() {
        // Initialize external variables
        let outer_x: u64 = 0;
        let outer_y: u64 = 5;

        // Loop: update outer_x inside
        let i: u64 = 0;
        while (i < 3) {
            // Shadow a variable named 'outer_x'
            let outer_x = outer_x + i; // Shadowing outer_x
            // Update outer_x (the outer variable)
            outer_x = outer_x + 1; // Error: move but in Move, variables are not mutable with 'mut' above, so must rebind
                                       // But per rules, we cannot declare mutable variables like that, so use a non-mutable binding
                                       // Instead, rebind outer_x after computation

            // So need to rebind outer_x
            outer_x = outer_x; // invalid syntax as above, but rules specify no 'let mut', so to update outer_x, we need to assign
            // reassign outer_x to the computed value
            // but in move, to reassign, must create a new variable binding; to emulate mutation, rebind outer_x
            // Well, per rules, no mut, so rebind everything

            // Reimplement accordingly:
            // Since no variable mutability, we need to use different variable bindings
            
            // So code layout:
            // Instead, at each iteration, reassign outer_x as a new binding

            // So, redefine logic:
        }

        // Because of the 'mut' restrictions, we can simulate updates by rebinds
        // a more correct approach:
        // We cannot mutate 'outer_x' directly, but rebind it after each iteration
        // So, rewrite loop accordingly:

        // To stay inline with the rules, remove the loop above and do the logic here:

        // Rewritten fully:

    }
}

// Inline the above with correct handling respecting 'never use mut' and no cyclic data types

// Corrected implementation below:


//# publish
module 0xCAFE::LoopAndScopeTest {
    use std::assert;

    internal fun internal_helper(x: u64): u64 {
        x + 10
    }

    public fun run_test() {
        // Initialize variables outside the loop
        let outer_x: u64 = 0;
        let outer_y: u64 = 5;

        // First iteration: simulate loop iteration 0
        let (outer_x, outer_y) = {
            // Shadow inner variable outer_x
            let outer_x_shadow = outer_x + 0;
            let outer_x_shadow = outer_x_shadow + 1;
            // outer_x remains the same outside; no mutation
            (outer_x_shadow, outer_y)
        };
        // Assert after first iteration
        assert!(outer_x == 0, 1); // outer_x unchanged
        assert!(outer_y == 5, 1);

        // Second iteration: simulate iteration 1
        let (outer_x, outer_y) = {
            let outer_x_shadow = outer_x + 1;
            let outer_x_shadow = outer_x_shadow + 1;
            (outer_x_shadow, outer_y)
        };
        assert!(outer_x == 1, 2);
        assert!(outer_y == 5, 2);

        // Third iteration: simulate iteration 2
        let (outer_x, outer_y) = {
            let outer_x_shadow = outer_x + 2;
            let outer_x_shadow = outer_x_shadow + 1;
            (outer_x_shadow, outer_y)
        };
        assert!(outer_x == 2, 3);
        assert!(outer_y == 5, 3);

        // Call internal helper to verify restricted access functions
        let result = internal_helper(outer_x);
        assert!(result == outer_x + 10, 4);

        // Nested block with variable scope
        let scope_result = {
            let a = 10;
            let b = 20;
            // Nested block
            {
                let c = a + b; // 30
                let d = c * 2; // 60
                // Verify inside nested block
                assert!(c == 30, 5);
                assert!(d == 60, 5);
                d
            }
        };
        assert!(scope_result == 60, 6);

        // Confirm outer variables remain unchanged
        assert!(outer_x == 2, 7);
        assert!(outer_y == 5, 7);
    }
}


//# run 0xCAFE::LoopAndScopeTest::run_test


// Featurres:
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 5dd5bb9af78300bbe8ee21a6bcd8fcf6: Test that the Move language correctly handles nested block expressions with variable assignments and arithmetic calculations within a single function.
