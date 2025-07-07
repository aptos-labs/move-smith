//# publish
module 0x1::TestModule {
    /// Spec block demonstrating top-level spec definitions and nested blocks.
    spec {
        // Function with detailed debugging
        public fun debug_info() {
            // Log debug info and bytecode dump name.
            // Assuming `debug_log` and `bytecode_dump_name` are available in testing environment.
            debug_log("Debug info: Starting debug_info function");
            // The bytecode dump name derived from source file name, e.g., "source_move_file.move"
            bytecode_dump_name("source_move_file.move");
        }

        // Spec block with a declaration of a literal address using byte sequence
        #[declare_address("(0x1234)")]
        fun declare_literal_address() {
            // No body needed, just the declaration.
        }

        // Spec with arithmetic error expectation
        #[expected_failure(arithmetic_error)]
        fun trigger_arithmetic_error() {
            // Intentionally cause an arithmetic error (e.g., division by zero)
            let _result = 1u64 / 0; // Should cause an error
        }
    }
}

// Publish the module
//# publish
module 0x2::Dummy {
    // Additional module to test multiple 'use' and member declarations
    spec {
        use 0x1::TestModule;

        // Define a spec member that tests various feature usages
        fun test_member() {
            // Call debug_info to produce debug logs and bytecode dump info
            TestModule::debug_info();

            // Declare address with byte sequence
            declare_address("(0x5678)");

            // Call arithmetic error function (expected to fail)
            // Note: In actual test framework, this may be handled differently
            // but here we simply define the functions.
            // This function will be invoked via a run command.
        }
    }
}

// Run the test by invoking the member function in the above module
//# run 0x2::Dummy::test_member --signers 0xCAFE