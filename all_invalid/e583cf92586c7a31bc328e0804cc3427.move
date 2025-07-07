//# publish
module 0xCAFE::TestModule {
    // Define a struct with some abilities for testing
    struct TestStruct has store, key, drop {}

    // Function to create and publish a resource
    public fun create_test_struct() {
        let ts = TestStruct {};
        move_to<TestStruct>(&signer, ts);
    }

    // Function to read the resource (if published)
    public fun get_test_struct(): &mut TestStruct {
        borrow_global_mut<TestStruct>(&0xCAFE)
    }

    // Helper function: intentionally aborts in an expression to test handling
    public fun abort_in_expr() {
        // Intentionally aborts here; used to test runtime abort detection
        abort 999;
        // Some dummy code after abort (not reachable)
    }

    // A function to perform a binary operation with an abort expression in operand
    public fun test_binary_op_with_abort() {
        // The following line tries to evaluate abort_in_expr() as an operand, which aborts
        let _ = 1 + abort_in_expr() as u64;
        // The above line should trigger abort before this line if run
    }
}

//# run 0xCAFE::TestModule::create_test_struct
// This prepares the resource for subsequent tests

//# run 0xCAFE::TestModule::test_binary_op_with_abort
// This test should trigger an abort during execution, testing error handling

// Note: Since test_binary_op_with_abort involves an abort inside an expression, the VM should handle abort gracefully during execution

//# run 0xCAFE::TestModule::get_test_struct
// To verify that the resource creation does not interfere with abort tests

//# run 0xCAFE::TestModule::abort_in_expr
// Testing abort inside an expression during runtime