// The original code had multiple structural issues: top-level scripts used as blocks, invalid tokens, misplaced 'move_call' invocations, and syntax errors. 
// Move scripts should be within functions, and 'move_call' is a function call, not a statement outside functions. 
// Also, the comments like `
//# run`, `

//# publish
module 0xCAFE::TestScript {

    use std::signer;

    // Helper function to perform move_call (simulate the testing harness)
    // In actual tests, these would be macros or test framework calls
    fun run_storage_usage_tests(s: &signer) {
        // Assuming the functions exist in 0xCAFE::StorageUsage
        // Store at signer address
        // Call the function in a way that would be tested
        // The move_call syntax in Move scripts isn't used like this, but for testing, assume it as a placeholder
        // Actual code would be invoke via entry functions or test harness
        // Here, for demonstration, we call the functions directly

        // Store a new object at signer's address
        0xCAFE::StorageUsage::store_at_signer_address(s, 9u8, 8u8);

        // Inspect value
        let (x, y) = 0xCAFE::StorageUsage::inspect_value(s);

        // Update value
        0xCAFE::StorageUsage::update_value(s, 7u8, 6u8);

        // Inspect again
        let (x2, y2) = 0xCAFE::StorageUsage::inspect_value(s);

        // Remove object
        0xCAFE::StorageUsage::remove_at_signer_address(s);

        // Cross module call
        0xCAFE::StorageUsage::cross_module_call(s);

        // Several args call
        0xCAFE::StorageUsage::several_args(s, 0xBEEF, 0xAAAA, 10u8, 20u8);
    }

    fun run_internal_test(s: &signer) {
        // Call internal function via public wrapper
        0xCAFE::InternalTest::call_internal_modify(s, &mut 0u64);
    }

    fun run_variable_shadowing_test() {
        // Setup variables
        let outer_var: u64 = 0;
        let inner_var: u64 = 5;

        // Shadow outer_var with inner block
        {
            let inner_var: u64 = 42;
            // inner_var inside this block is 42
        }
        // outside block, inner_var is 5

        // Loop with shadowing
        let test_var: u64 = 42;

        let i: u64 = 0;
        // Move does not support 'for' syntax; simulate with a while loop
        let index: u64 = 0;
        while (index < 3) {
            let inner_var: u64 = index;
            // check inner_var == index
            assert!(inner_var == index, 0);
            // shadow outer_var
            let outer_var_in_loop: u64 = index + 10;
            assert!(outer_var_in_loop == index + 10, 0);
            index = index + 1;
        }

        // validate outer scope variables
        assert!(test_var == 42, 0);
        assert!(outer_var == 0, 0);
        // For inner shadowed var, we cannot check directly as it was shadowed
    }

    fun run_internal_function_access() {
        // Declare mutable val
        let val: u64 = 0;
        // Call the public wrapper to modify value
        0xCAFE::InternalTest::call_internal_modify(signer::address_of(&signer), &mut val);
        // Validate val incremented
        assert!(val == 1, 0);
    }

    fun run_variable_shadowing_scope() {
        let outer_scope_var: u64 = 10;
        let shadowed_var: u64 = 100;

        let inner_shadowed_var: u64 = shadowed_var; // shadowing outside

        let inner_scope_var: u64 = inner_shadowed_var + 20;

        let shadowed_var = inner_scope_var; // shadow again

        assert!(outer_scope_var == 10, 0);
        assert!(shadowed_var == 70, 0);
    }

    // Entry function to run all tests
    public fun run_tests(s: &signer) {
        run_storage_usage_tests(s);
        run_internal_test(s);
        run_variable_shadowing_test();
        run_internal_function_access();
        run_variable_shadowing_scope();
    }
}
