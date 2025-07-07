
//# publish
module 0xDEAD::VariableScopeTest {
    use std::signer;
    use std::vector;

    // Struct resource to hold internal state if needed (not strictly required here)
    // but added for internal resource encapsulation if needed.
    struct TestResource {
        dummy: bool
    }

    // Internal function, not accessible outside the module
    fun internal_helper() {
        // empty internal helper
    }

    // Internal resource constructor (not used here but for demonstration)
    fun internal_create(s: &signer) {
        move_to(s, TestResource { dummy: true });
    }

    // Public entry function to run the whole test scenario
    public fun run_tests(s: &signer) {
        // Call reserved keyword-like function
        for_loop_variable_test(s);
        // Call testing variable scope and shadowing
        test_variable_shadowing(s);
        // Call internal function to ensure encapsulation
        // (Can't call directly outside, only from internal functions)
        internal_helper();
    }

    // Function with reserved keyword name 'for'
    public fun for(s: &signer) {
        // Simple counter
        let count = 0;
        while (count < 3) {
            count = count + 1;
        };
        assert!(count == 3, 1001);
    }

    // Function to test variable scoping and shadowing with while loop
    public fun test_variable_shadowing(s: &signer) {
        let outer_var = 42;
        let result_inner = 0;
        let result_outer = outer_var;
        let _shadow_inner = 0;

        let _temp = 0; // shadowing inner variable

        // Declare a variable before the loop
        let x = 10;

        while (x > 0) {
            // Shadow variable within loop
            let x = x - 1;
            // Assign to inner variable
            result_inner = x;
            // Change outer variable
            result_outer = result_outer + x;
            // Shadow inner variable with same name
            let _shadow_inner = x + 100;
        };

        // After loop, variables should have expected values
        // x should be 0 after loop
        assert!(x == 10 - 10, 1002);
        // result_inner should be 0 (last value x had in loop)
        assert!(result_inner == 0, 1003);
        // result_outer should be initial 42 + sum of x values from 9 down to 0
        let expected = 42 + (9 + 8 + 7 + 6 + 5 + 4 + 3 + 2 + 1 + 0);
        assert!(result_outer == expected, 1004);
    }
}


//# run 0xDEAD::VariableScopeTest::for --signers 0xFEED


//# run 0xDEAD::VariableScopeTest::run_tests --signers 0xFEED


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 36c0747efc0d381d827c603922045c9c: Test that functions can be named using reserved keywords such as 'for' without causing parsing or compilation errors.
