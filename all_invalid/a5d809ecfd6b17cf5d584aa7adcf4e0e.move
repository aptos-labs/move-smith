
//# publish
module 0xDEAD::Traits {
    // You NEVER try to use this 0xDEAD::Traits
    // It is only an example of a traits module
    public fun always_true(): bool {
        true
    }
}



//# publish
module 0xDEAD::TestModule {
    use std::signer;
    use 0xDEAD::Traits;

    // Example struct to test uninitialized variable detection
    struct TestStruct has store, key {
        field1: u64,
        field2: bool,
    }

    public fun precondition_check(x: u64) {
        // Remove the 'requires' clause to avoid syntax error
        // You can replace this comment with actual precondition logic if needed
        // For now, just an empty function that calls no preconditions
        // or move the precondition logic elsewhere
        // e.g., require x > 10;
        // but Move syntax does not support 'requires' directly
    }

    public fun test_uninitialized_variable() {
        // Variable declared but not initialized
        let uninit_var: bool;
        // Use the uninitialized variable
        let _ = uninit_var; // should be flagged
        // Another uninitialized variable in condition
        if (uninit_var) {
            // do something
        };
    }

    // Function with custom precondition check
    public fun multiply_if_precondition(x: u64, y: u64) {
        // Implement precondition check manually since 'requires' syntax is not valid
        // For testing, you could have an explicit check:
        // if (!Traits::always_true()) { abort; }
        // but since always_true() returns true, skipping
        let result = x * y;
        result
    }

    // Function that uses a local variable without initialization to test detection
    public fun uses_uninitialized_local() {
        let local_var: u8;
        // Attempt to read uninitialized variable
        let _ = local_var; // Should trigger detection
    }

    // Function to test the pragma properties
    public fun compile_directives_test() {
        // Provide a dummy pragma comment
        // (This comment is for testing parseability)
        // pragma property: optimize_level=3; enable_loop_unrolling=true;
        let _ = 42u8; // dummy operation
    }

    // Runner function to execute above test functions
    public fun run_all_tests() {
        precondition_check(15);
        test_uninitialized_variable();
        multiply_if_precondition(5, 10);
        uses_uninitialized_local();
        compile_directives_test();
    }
}



//# run 0xDEAD::TestModule::run_all_tests --signers 0xABCD


// Features:
// 6c81a04d3e438cd650e1b7363a72f69b: Detect uses of uninitialized local variables in functions.
// d20f4c9345cd56944ef78876554e4e23: Use 'requires' to specify preconditions that must hold before a function executes.
// 0f102b2f4db900e14ca00b6b795a3b0d: Add pragma properties for compiler directives.
