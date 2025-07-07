
//# publish
module 0xCAFE::LoopAndScopeTest {
    use std::assert;

    // Move does not support 'internal' visibility; use 'public' or omit.
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    public fun run_test() {
        // Initialize variables outside the loop
        let outer_x: u64 = 0;
        let outer_y: u64 = 5;

        // Simulate first iteration
        let (outer_x, outer_y) = {
            // Shadow inner variable 'outer_x'
            let outer_x_shadow = outer_x + 0;
            let outer_x_shadow = outer_x_shadow + 1;
            (outer_x_shadow, outer_y)
        };
        // Verify after first iteration
        assert!(outer_x == 0, 1);
        assert!(outer_y == 5, 1);

        // Second iteration
        let (outer_x, outer_y) = {
            let outer_x_shadow = outer_x + 1;
            let outer_x_shadow = outer_x_shadow + 1;
            (outer_x_shadow, outer_y)
        };
        assert!(outer_x == 1, 2);
        assert!(outer_y == 5, 2);

        // Third iteration
        let (outer_x, outer_y) = {
            let outer_x_shadow = outer_x + 2;
            let outer_x_shadow = outer_x_shadow + 1;
            (outer_x_shadow, outer_y)
        };
        assert!(outer_x == 2, 3);
        assert!(outer_y == 5, 3);

        // Call internal helper
        let result = internal_helper(outer_x);
        assert!(result == outer_x + 10, 4);

        // Nested block with variable scope
        let scope_result = {
            let a = 10;
            let b = 20;
            {
                let c = a + b; // 30
                let d = c * 2; // 60
                // Inside nested block
                assert!(c == 30, 5);
                assert!(d == 60, 5);
                d
            }
        };
        assert!(scope_result == 60, 6);

        // Verify outer variables remain unchanged
        assert!(outer_x == 2, 7);
        assert!(outer_y == 5, 7);
    }
}
