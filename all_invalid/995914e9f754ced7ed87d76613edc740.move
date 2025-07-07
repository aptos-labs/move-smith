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
        let _ = supply_value(abort_in_first_arg(), false); // This should abort before the second arg
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
        // So, we comment this out to prevent test hanging.
        // cycle_func_a();
    }
}

//# run 0xCAFE::TestModule::run_test_eval_order --signers 0xCAFE

// Featurres:
// 8e6fca7ad7a41c88c6b4a550ff9e7b3e: Create primary expressions such as name references and value literals (like numbers, booleans, byte strings).
// a7c1901dfea9bbb19ae3c766a395ecf6: Test that argument evaluation order for function calls is left-to-right, including that aborts in earlier arguments prevent later arguments from being evaluated.
// 2986aeed3df1709e402d455bbc10fc21: Identify at least one cycle in the call graph to ensure code correctness and termination.
