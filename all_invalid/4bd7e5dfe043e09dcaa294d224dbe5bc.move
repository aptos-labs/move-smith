module 0xCAFE::TestModule {
    use std::signer;
    use std::vector;

    // Helper function to create a signer (simulate)
    fun create_signer(): signer {
        // Placeholder for signer creation, normally provided by the test environment
        // For the purpose of compilation, return an existing signer
        // In real tests, replace with actual signer creation
        abort 0;
    }

    // A function to run inline: test move variable and script with import
    public fun test_move_and_script() {
        // Declare a variable and move it
        let x = 42u64;
        let y = move x; // move x into y; x is no longer valid after move
        // Use the move variable y in an assertion
        assert!(y == 42, 42);
    }

    // The run of the above function in the test
    public fun run_test_move_and_script() {
        Self::test_move_and_script();
    }
}


//# run 0xCAFE::TestModule::run_test_move_and_script