
//# publish
module 0xCAFE::test_module_bool_args {
    // Struct with unused type parameters to test compiler's removal of unused params
    struct DummyStruct<UnusedType> {
        value: bool,
        // No use of UnusedType to test removal
    }

    // Function to return boolean literals
    public fun return_true(): bool {
        true
    }

    public fun return_false(): bool {
        false
    }

    // Helper functions to test argument evaluation order and aborts
    public fun abort_in_first(arg1: bool, _arg2: u8): bool {
        // Abort intentionally
        abort 42
    }

    public fun evaluate_arguments_guarded(arg1: bool, _arg2: u8): bool {
        // Should not be called if abort in first argument triggers
        true
    }

    // Runner function to test argument evaluation order
    public fun test_argument_evaluation() {
        // Call abort_in_first; second argument should not be evaluated
        abort_in_first(return_true(), 123u8);
        // The following should not be executed
        evaluate_arguments_guarded(return_false(), 0u8);
    }
}



//# run 0xCAFE::test_module_bool_args::test_argument_evaluation --signers 0xCAFE



//# run 0xCAFE::test_module_bool_args::return_true --signers 0xCAFE


//# run 0xCAFE::test_module_bool_args::return_false --signers 0xCAFE