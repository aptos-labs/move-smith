//# publish
module 0x1::TestModule {
    /// Top-level spec block: a function with some logic
    public fun spec_function() {
        // For testing, log a message (if supported) or perform a simple operation
        // Move doesn't have native logging, but we can simulate some debug info via bytecode.
    }

    /// Log detailed debug info - simulate by dumping bytecode info
    public fun log_debug_info() {
        // This function could be a placeholder to simulate debug info output
        // In actual testing, the compiler logs are checked, but here we just define the function
    }

    /// Declare a literal address specifier with bytecode
    public fun literal_address_specifier() {
        let addr_bytes = (0x1234u16).to_bytes();
        // Simulate using the byte sequence as an address
        // For testing, just return or drop
    }

    /// External visible function marked as public
    public fun externally_visible_function() {
        // Placeholder function for external visibility
    }

    /// External visible function marked as friend (simulate via public)
    public fun friend_function() {
        // Placeholder
    }

    /// Runner function to execute spec logic without args
    public fun run_spec_tests() {
        spec_function();
        log_debug_info();
        literal_address_specifier();
        externally_visible_function();
        friend_function();
    }
}

//# run 0x1::TestModule::run_spec_tests --signers 0x1

//# publish
module 0x2::AdditionalFeatures {
    /// Function to include top-level spec block
    public fun top_level_spec() {
        // No operation
    }

    /// Function to enable detailed debug info logging
    public fun enable_debug_logging() {
        // No operation
    }

    /// Function to declare a literal address specifier
    public fun declare_address_literal() {
        let addr = (0xABCDu16).to_bytes();
        // Use or return None
    }

    /// Function marked as friend
    public fun friend_visibility() {
        // No operation
    }

    /// Run all in one
    public fun run_all() {
        top_level_spec();
        enable_debug_logging();
        declare_address_literal();
        friend_visibility();
    }
}

//# run 0x2::AdditionalFeatures::run_all --signers 0x2