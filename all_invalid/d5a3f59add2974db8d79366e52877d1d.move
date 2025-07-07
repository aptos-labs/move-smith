
//# publish
module 0xABCD::InnerModule {
    // This internal function simply returns a fixed value
    fun internal_add(x: u8, y: u8): u8 {
        x + y
    }
    
    public fun call_internal_add(x: u8, y: u8): u8 {
        internal_add(x, y)
    }
}


//# publish
module 0xABCD::MainVerifier {
    use 0xABCD::InnerModule;
    use std::assert;

    // Entry function for testing the complex control flow and variable shadowing
    public fun test_control_flow_and_shadowing() {
        // Initialize local variables
        let v_outer = 0u8;
        let v_inner = 0u8;

        // First, perform a simple while loop with variable shadowing
        let counter = 0u8;
        while (counter < 3) {
            // Shadow previous 'counter'
            let counter = counter + 1;
            // update v_outer with new counter value
            let v_outer = counter;

            // nested loop capturing inner scope
            let inner_counter = 0u8;
            while (inner_counter < 2) {
                let inner_counter = inner_counter + 1;
                // shadow v_inner with inner_counter
                let v_inner = inner_counter;
                // Use internal function
                let sum = InnerModule::call_internal_add(v_outer, v_inner);
                // Assert sum is correct
                assert!(sum == v_outer + v_inner, 888);
            };
        };

        // After loops, check variables
        // v_outer should be 3
        assert!(v_outer == 3, 999);
        // v_inner should be 2 (last inner loop value)
        assert!(v_inner == 2, 999);
        
        // Nested loops with shadowing to test complex scope
        let outer_shadow = 0u8;
        // Note: move doesn't support 'for i in 0..3' directly; need to use while loop for iteration
        let i = 0u8;
        while (i < 3) {
            // Shadowing outer_shadow
            let outer_shadow = i + 10;
            // inner loop for j
            let j = 0u8;
            while (j < 2) {
                let j = j + 1; // shadow j
                // Call internal function
                let _ = InnerModule::call_internal_add(outer_shadow, j);
                j = j + 0; // dummy to mutate j or leave as is
                // Since variables are immutable by default, need to assign j = j + 1 each iteration
                // But in Move, variables are re-bound, so do: j = j + 1;
            }
            // increment i
            i = i + 1;
            // Outer shadow variable should now be i + 10
            assert!(outer_shadow == i - 1 + 10, 888);
            i = i + 1;
        };

        // No return needed
    }
}

// Tests calling internal functions from outside should be restricted.
// The following line, if uncommented, should fail if internal call is attempted here, but in this scope it's valid.
// assert!(InnerModule::internal_add(1, 2) == 3, 999); // Should not compile due to internal visibility

// Run entry point to verify everything


//# run 0xABCD::MainVerifier::test_control_flow_and_shadowing
