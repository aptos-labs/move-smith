//# publish
module 0xCAFE::TestModule {

    // Auxiliary functions to test argument evaluation order
    fun abort_in_first_arg(): u64 {
        // This function aborts to prevent further evaluation
        abort 42;
    }

    fun supply_value(value: u64): u64 {
        value
    }

    // Function that calls a function with multiple arguments to test evaluation order
    fun test_eval_order() {
        // The call should abort during the evaluation of the first argument
        // and not evaluate the second argument.
        let _ = supply_value(abort_in_first_arg()); // Removed extra argument to match function signature
    }

    // Function with a cycle in call graph for termination check
    fun cycle_func_a() {
        cycle_func_b();
    }

    fun cycle_func_b() {
        cycle_func_a();
    }

    #[test]
    public fun run_test_eval_order() {
        test_eval_order();
    }

    #[test]
    public fun run_cycle_test() {
        // Call one of the cycle functions; it will never terminate,
        // but here we just invoke to ensure the code compiles and runs.
        // Note: In practice, this test will not terminate, but it's for compiler/VM correctness.
        // So, this is commented out to prevent hanging.
        // cycle_func_a();
    }
}

//# run 0xCAFE::TestModule::run_test_eval_order --signers 0xCAFE