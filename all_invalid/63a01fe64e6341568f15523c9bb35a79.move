
//# publish
module 0xCAFE::LoopVariableTests {
    use std::signer;

    // Internal function, not accessible outside
    fun internal_helper(x: u64): u64 {
        x + 10
    }

    // Public function that calls internal
    public fun call_internal_helper(x: u64): u64 {
        internal_helper(x)
    }
}



//# run 0xCAFE::LoopVariableTests::call_internal_helper --args 5u64


//# publish
module 0xCAFE::LoopVariableScope {
    // Test module for variable scope inside and outside loops
    use std::assert;

    // Function to create local variables and test shadowing
    public fun test_variable_shadowing_in_loop(): (u64, u64) {
        let outer_var = 0u64;
        let outer_shadowed = outer_var; // Save outer variable for comparison

        let inner_var: u64 = 0;

        let _ = while (inner_var < 3) {
            let outer_var = inner_var + 100; // shadow outer_var
            // inside loop, outer_var refers to inner shadow
            // Let's assert its value
            assert!(outer_var == inner_var + 100, 999);
            inner_var = inner_var + 1u64;
            ();
        };
        // After loop, outer_var should remain unchanged
        (outer_shadowed, outer_var)
    }

    // Function to test variable update correctness outside loop
    public fun test_variable_after_loop(): (u64, u64) {
        let x = 0u64;
        let y = x;

        let _ = while (y < 5) {
            let _temp = y + 1;
            y = y + 1;
            ();
        };
        (x, y)
    }
}



//# run 0xCAFE::LoopVariableScope::test_variable_shadowing_in_loop

//# run 0xCAFE::LoopVariableScope::test_variable_after_loop


//# publish
module 0xCAFE::AccessRestrictions {
    use std::assert;

    // Internal function, only accessible within this module
    fun internal_function(): u64 {
        42
    }

    // Public function
    public fun call_internal(): u64 {
        internal_function()
    }

    // Attempt to expose internal function outside module (should not compile if uncommented)
    // public fun outside_access(): u64 {
    //     internal_function()
    // }
}


//# run 0xCAFE::AccessRestrictions::call_internal

// Note: no external code should call internal_function, ensuring visibility restrictions are enforced.


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
