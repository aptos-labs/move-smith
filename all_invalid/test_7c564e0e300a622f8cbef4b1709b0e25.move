//# publish
module 0x99::ShadowAndBlockTest {

    public fun run_shadowed_in_closure() {
        let outer_var = 0;
        // Inner closure that captures outer_var
        let update_outer = |new_value: u64| {
            outer_var = new_value;
        };
        update_outer(42);
        assert!(outer_var == 42, 0);
    }

    public fun test_shadow_in_closure() {
        let val = 5;
        // Shadowing inner variable within a nested block
        let result = {
            let val = 10; // New variable within this block, shadows outer
            // Call function that modifies outer variable
            run_shadowed_in_closure();
            val // Return inner val
        };
        // Ensure that outer val remains unchanged
        assert!(result == 10, 0); // Confirm inner shadow
        // Verify outer variable unaffected by inner shadow
        let outer_val = 0;
        // Re-run to check a variable outside the block is unaffected
        let x = 1;
        {
            let x = 99; // shadow
            x = x + 1; // local modification
        }
        assert!(x == 1, 0); // outer x remains 1
    }
}

//# run 0x99::ShadowAndBlockTest::test_shadow_in_closure
