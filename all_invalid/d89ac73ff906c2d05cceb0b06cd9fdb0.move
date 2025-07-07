
//# publish
module 0xCAFE::TestModule {
    use std::signer;

    // Expose functions as entry points for scripts
    public fun run_feature_tests() {
        // Call internal functions via public wrappers (if needed)
        // No arguments for these internal test functions
        self::test_variable_shadows();
        self::test_loop_variable_shadowing();
        self::test_inaccessible_internal();
        self::test_function_specifications();
        self::test_closure_conditional_calls();
        self::test_combined_feature_sequence();
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
        self::internal_shadow_outer()
    }

    // Internal function to test variable states inside while with external variables
    fun internal_loop_shadow() {
        let i: u8 = 0;
        let j: u8 = 5;
        while (i < 3) {
            let i = i + 1; // shadow outer i each iteration
            let j = j + 1; // shadow outer j
        };
        // Ensure outer variables hold expected values
        (i, j)
    }

    // External wrapper for loop variable shadowing test
    public fun test_loop_variable_shadowing() {
        internal_loop_shadow()
    }

    // Internal functions with restricted visibility
    fun internal_private_function(): u8 {
        42
    }

    // Attempt to call internal function from outside module should be impossible; test that via a public wrapper
    public fun call_internal_private(): u8 {
        internal_private_function()
    }

    // Function with spec to check correctness; should be pure
    public fun verified_add(a: u64, b: u64): u64 {
        // precondition: a + b does not overflow u64
        // postcondition (implied): returns correct sum
        a + b
    }

    // Function with specific pre/post conditions to test spec enforcement
    public fun check_spec(a: u64, b: u64): u64 {
        // pre: a <= 1000 && b <= 1000
        assert!(a <= 1000, 100);
        assert!(b <= 1000, 101);
        let sum = verified_add(a, b);
        // post: sum = a + b
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
        let _ = self::test_variable_shadows();
        // Call loop shadowing test
        let _ = self::test_loop_variable_shadowing();
        // Call internal function via wrapper (should succeed)
        let _ = self::call_internal_private();
        // Run spec test
        let _ = self::check_spec(500u64, 400u64);
        // Test closure conditional
        let (res1, res2) = self::test_closures();
        (res1, res2)
    }
}


//# run 0xCAFE::TestModule::run_feature_tests


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 7f343e5b6a46a90c5e940d2d1b876be9: Test that function currying with different closures correctly evaluates conditional logic and produces expected results.
