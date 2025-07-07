//# publish
module 0xDEADBEEF::TestModule {
    /// Top-level spec block: an example function with a spec annotation
    public fun spec_example() {
        // Implementation can be empty for this test
    }

    /// Function that logs a debug message including bytecode dump name (simulated)
    public fun log_debug_info() {
        // In actual implementation, this would log debug info including the dump name
        // Here, we just simulate the presence of debug info
        // (In Move, actual debug logging may require std::debug or custom print macros)
        // For compiler testing, the presence of debug info in bytecode is sufficient
    }

    /// Declare a literal address specifier with a byte sequence (e.g., (0x1234))
    public fun declare_literal_address(): address {
        // The address literal as a byte sequence
        (0x1234).to_address()
    }

    /// Runner function to invoke other functions
    public fun run_all() {
        // Call the debug logging function
        Self::log_debug_info();
        // Declare address literal
        let addr = Self::declare_literal_address();
        // Optionally, do something with the address
        // (For the test, just a no-op)
    }
}

//# run 0xDEADBEEF::TestModule::run_all --signers 0xDEADBEEF