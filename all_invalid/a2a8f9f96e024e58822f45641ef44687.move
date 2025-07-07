
//# publish
module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Internal helper function with restricted access
    fun internal_compute(x: u64, y: u64): u64 {
        x + y
    }

    // Public script entry point to test variable scope in loops and shadowing
    public fun script_variable_scope(s: signer, init_value: u64) {
        let outer_var = init_value;
        let inner_shadowed_var: u64 = 0;

        // First, variable outside while loop
        while (outer_var < 5) {
            let outer_var = outer_var * 2; // shadow outer_var inside loop
            inner_shadowed_var = outer_var + 10;
            outer_var = outer_var + 1;
        };
        // outer_var here should be unchanged (since shadowed inside loop)
        // inner_shadowed_var should hold last assigned value
        // No assertions included, just flow
        ()
    }

    // Public script to test local variable assignment outside loops
    public fun script_variable_assignment(s: signer) {
        let count = 0u64;
        while (count < 3) {
            let tmp = count + 5;
            count = count + tmp;
        };
        // after loop, count should be 0 + (5 + 10 + 15)
        ()
    }

    // Function with variable shadowing in inner block scopes
    public fun shadowing_test(x: u64): u64 {
        let y = x;
        if (x > 0) {
            let y = y + 1; // shadow y
            y
        } else {
            y
        }
    }

    // Private internal function to test access restriction
    fun internal_helper(a: u64): u64 {
        a * 2
    }

    // Public function that calls internal helper
    public fun public_helper_call(val: u64): u64 {
        internal_helper(val)
    }

    // Native function to simulate critical computation
    native public fun native_add(a: u64, b: u64): u64;

    // Script to test calling native function directly
    public fun script_call_native_add(a: u64, b: u64): u64 {
        native_add(a, b)
    }

    // Helper function to verify external access restriction (simulate by attempting to call internal from outside)
    // We do not expose internal directly; we test that outside modules cannot call internal
    // So no code here, just rely on access restrictions in real tests.
}


//# run 0xCAFE::TestModule::script_variable_scope --signers 0xBEEF --args 10u64

//# run 0xCAFE::TestModule::script_variable_assignment --signers 0xBEEF

//# run 0xCAFE::TestModule::shadowing_test --args 5u64

//# run 0xCAFE::TestModule::public_helper_call --args 7u64

//# run 0xCAFE::TestModule::script_call_native_add --args 12u64 34u64


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c9fa821c04c5061fa871fb56b9e6f584: Define functions (including possibly native functions) in a module.
