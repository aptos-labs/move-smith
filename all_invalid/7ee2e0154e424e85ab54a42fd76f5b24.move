//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Expose functions as entry points for scripts
    public fun run_feature_tests() {
        // Call internal functions via public wrappers
        // No arguments for these internal test functions
        Self::test_variable_shadows();
        Self::test_loop_variable_shadowing();
        Self::test_inaccessible_internal();
        Self::test_function_specifications();
        Self::test_closure_conditional_calls();
        Self::test_combined_feature_sequence();
    }

    // Internal function to test variable shadowing inside and outside while
    fun internal_shadow_var(x: u8): u8 {
        x
    }

    // Internal function to test variable shadowing
    fun internal_shadow_outer() {
        let shadow_var: u8 = 10;
        let _ = internal_shadow_var(shadow_var);
        // Shadow variable inside while loop
        let shadow_var = 20;
        while (shadow_var < 25) {
            let shadow_var = shadow_var + 1; // shadow with same name
            // shadow_var inside loop
        };
        // After loop, shadow_var should be 20 (original)
        shadow_var
    }

    // External wrapper to test variable shadowing
    public fun test_variable_shadows() {
        Self::internal_shadow_outer()
    }

    // Internal function to test variable states inside while with external variables
    fun internal_loop_shadow() {
        let i: u8 = 0;
        let j: u8 = 5;
        let i_var = i;
        let j_var = j;
        while (i_var < 3) {
            let i = i_var + 1; // shadow outer i
            let j = j_var + 1; // shadow outer j
            // carry on looping, updates are local
            i_var = i; 
            j_var = j;
        };
        // return the values after loop
        (i_var, j_var)
    }

    // External wrapper for loop variable shadowing test
    public fun test_loop_variable_shadowing() {
        Self::internal_loop_shadow()
    }

    // Internal functions with restricted visibility
    fun internal_private_function(): u8 {
        42
    }

    // Wrapper to call internal function
    public fun call_internal_private(): u8 {
        internal_private_function()
    }

    // Function with spec to check correctness; should be pure
    public fun verified_add(a: u64, b: u64): u64 {
        // precondition: a + b does not overflow u64
        a + b
    }

    // Function with specific pre/post conditions to test spec enforcement
    public fun check_spec(a: u64, b: u64): u64 {
        assert!(a <= 1000, 100);
        assert!(b <= 1000, 101);
        let sum = verified_add(a, b);
        sum
    }

    // Functions to test currying and nested conditional closures
    public fun outer_closure(flag: bool): |u8|u8 {
        if (flag) {
            |x: u8| x + 1
        } else {
            |x: u8| x + 2
        }
    }

    public fun inner_closure_eval() {
        let f1 = outer_closure(true);
        let result_true = f1(10);
        let f2 = outer_closure(false);
        let result_false = f2(10);
    }

    // Function for nested or sequential calls to verify evaluation
    public fun test_closures() {
        let add_one = outer_closure(true);
        let val1 = add_one(5);
        let add_two = outer_closure(false);
        let val2 = add_two(5);
        (val1, val2)
    }

    // Sequence test to verify all features combined
    public fun combined_sequence() {
        // Call variable shadowing test
        let _ = Self::test_variable_shadows();
        // Call loop shadowing test
        let _ = Self::test_loop_variable_shadowing();
        // Call internal function via wrapper (should succeed)
        let _ = Self::call_internal_private();
        // Run spec test
        let _ = Self::check_spec(500u64, 400u64);
        // Test closure conditional
        let (res1, res2) = Self::test_closures();
        (res1, res2)
    }
}
