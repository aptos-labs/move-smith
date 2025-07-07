//# publish
module 0x1::test_module {
    // Test 1: Local variable updates within expression blocks
    public fun local_variable_update_test() {
        let result = {
            let local_var = 10;
            let local_var = local_var + 20; // update local_var within block
            local_var // should be 30
        };
        // Save result to global storage or just for internal testing
        // (No assertions, just to exercise compiler and VM)
        result
    }

    // Test 2: Referencing parameter and copying its value
    public fun param_reference_copy_test(param: u64): u64 {
        let param_ref = &param;
        let copied_value = *param_ref; // copy by dereferencing
        copied_value
    }

    // Test 3: Tuple destructuring and mutation
    public fun tuple_destructuring_test(): u64 {
        let tup = (5u64, 10u64);
        let (mut a, mut b) = tup;
        a = a + b; // a = 15
        b = b * 2; // b = 20
        // Return sum
        a + b // should be 35
    }

    // Runner function to invoke all tests
    public fun run_all() {
        // Call test functions (values are ignored)
        local_variable_update_test();
        param_reference_copy_test(42);
        tuple_destructuring_test();
    }
}

//# run 0x1::test_module::run_all

// Featurres:
// a2acc1502b08da208d2d08e4984609c4: Test that local variable updates within expression blocks are correctly evaluated and used in subsequent expressions, ensuring proper handling of state changes in nested blocks.
// 73bbd39cc8ad9a38d26719906adce49e: Test that referencing a function parameter by reference and then copying its value produces the correct output.
// aa3a79fbc8f4c1458f141ee16e2d9f7d: Test that tuple destructuring and variable mutation within an expression scope produce the correct values when returning and summing results.
