
//# publish
module 0xCAFE::TestSuite {
    use std::vector;
    use std::signer;

    // Internal function for testing access restrictions
    fun internal_helper(): u8 {
        42
    }

    // Script entry points for testing variable scope, loops, and internal function calls

    public fun script_test_variable_scope_and_loops(s: &signer) {
        // Test variable assignment outside loop
        let outer_var = 0u64;

        // Outer scope while loop
        while (outer_var < 3) {
            // Variable shadowing in inner scope
            let inner_outer_var = outer_var + 1;

            // Inner scope for local variables
            let inner_var = inner_outer_var;

            // Reassign inner_var inside inner loop
            while (inner_var < inner_outer_var + 2) {
                let inner_var_in_loop = inner_var + 1;

                // Shadowing inner_var with same name, ensure scope isolation
                let inner_var = inner_var_in_loop + 1;

                // Optional: update inner_var if needed
                inner_var = inner_var + 1;
            }

            // Increment outer_var
            outer_var = outer_var + 1;
        };

        // After loops, verify outer_var value
        assert!(outer_var == 3, 999);
    }

    public fun script_test_internal_function_access(s: &signer): u8 {
        // Should be accessible within module
        internal_helper()
    }

    // Function with 'internal' visibility, no external access
    fun internal_function_for_test(): u8 {
        7
    }

    // A generic function with specific abilities to test capability constraints
    public fun test_ability_constraints<T: copy + store + drop>(t: T): T {
        t
    }

    // Wrappers for ability constraint tests - cannot be called from outside
    public fun run_copy_constraint(x: u8): u8 {
        test_ability_constraints<u8>(x)
    }

    // The following function is deliberately invalid (commented out)
    // to illustrate that such a call would cause compile-time error if attempted
    // public fun run_drop_constraint() {
    //     // Attempt to pass a reference which does not satisfy drop+copy
    //     let ref_value: &u8 = &98u8;
    //     // test_ability_constraints<&u8>(ref_value); // INVALID, should not compile
    // }
}



//# run 0xCAFE::TestSuite::script_test_variable_scope_and_loops --signers 0x0



//# run 0xCAFE::TestSuite::script_test_internal_function_access --signers 0x0



//# run 0xCAFE::TestSuite::run_copy_constraint --args 55u8


// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// c58ec5bcad183e685aa4157b1ddd27cf: Specify ability constraints (such as copy, drop, store) on function type parameters.
