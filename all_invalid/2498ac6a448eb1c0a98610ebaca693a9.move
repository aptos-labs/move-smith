
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

    // State variable to track internal state; not persistently stored for simplicity
    // Using local variables inside functions

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
            v_outer = counter;
            // nested loop capturing inner scope
            let inner_counter = 0u8;
            while (inner_counter < 2) {
                let inner_counter = inner_counter + 1;
                v_inner = inner_counter;
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
        for i in 0..3 {
            let outer_shadow = i + 10; // shadowing outer variable
            let j = 0u8;
            while (j < 2) {
                let j = j + 1; // shadow inner
                // Call internal function
                let _ = InnerModule::call_internal_add(outer_shadow, j);
            };
            // Outer shadow variable should now be i+10
            assert!(outer_shadow == i + 10, 888);
        };

        // Final check: ensure inner variables are as expected
         // No return needed, last expression is implicit
    }
}

// Tests calling internal functions from outside should be restricted.
// The following line, if uncommented, should fail if internal call is attempted here, but in this scope it's valid.
// assert!(InnerModule::internal_add(1, 2) == 3, 999); // Should not compile due to internal visibility

// Run entry point to verify everything

//# run 0xABCD::MainVerifier::test_control_flow_and_shadowing


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 5384dd53cb94407108d41c3fd47a4dc8: Define multiple modules in a single source file.
