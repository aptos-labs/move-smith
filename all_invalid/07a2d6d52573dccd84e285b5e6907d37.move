//# publish
module 0xCAFE::VariableVisibilityTest {
    // This module tests local variable handling, shadowing, internal visibility, and correctness of variable states across loops and function calls.

    use std::assert;

    // Internal function only accessible within this module
    fun internal_add(a: u64, b: u64): u64 {
        a + b
    }

    // Public script entry function to run variable and loop tests
    public fun script_run_variable_and_loop_tests() {
        // Declare a local variable before loop
        let outer_var: u64 = 10;

        // Loop to modify outer_var and shadow inner variable
        let i: u64 = 0;
        while (i < 3) {
            // Shadowed variable with same name inside loop
            let inner_var: u64 = outer_var + i;
            // Reassign outer_var based on inner_var
            outer_var = inner_var * 2;

            // Confirm inner_var's value at each iteration
            assert!(inner_var == (10 + i), 100);
            // Confirm outer_var's value after assignment
            assert!(outer_var == (inner_var * 2), 101);

            i = i + 1;
        };

        // After loop, outer_var should be ( (10 + 2) ) * 2 = 24
        assert!(outer_var == 24, 102);
    }

    // Public script to test internal function cannot be called externally
    public fun script_test_internal_function() {
        // Call internal function from within module
        let result = internal_add(3, 4);
        assert!(result == 7, 200);
    }
}


//# run 0xCAFE::VariableVisibilityTest::script_run_variable_and_loop_tests

//# run 0xCAFE::VariableVisibilityTest::script_test_internal_function

// Features:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 0b62e2b6ef6d21801ee5807769ee6a3e: Test that local variable assignments inside and outside a while loop are handled correctly and that variable shadowing does not affect values across loop iterations.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
