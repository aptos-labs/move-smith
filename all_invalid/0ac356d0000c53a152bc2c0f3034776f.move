//# publish
module 0xA1B2 {
    /// Top-level spec block with a function
    public fun top_level_spec() {
        // no operations here, just a placeholder to test spec block inclusion
    }

    /// Function to log detailed debug info
    public fun log_debug_info() {
        // Assuming debug functionality is available, we simulate logging bytecode dump name derived from source file name
        // In actual Move, logging might be via `logger::log()`; here, we just represent the intent.
        // Placeholder for debug log
        // debug_log("Debug: Dumping bytecode for source file: 'test_script.move'");
    }

    /// Declare a literal address specifier with a byte sequence
    public fun declare_address() {
        let addr_bytes = b"\\x01\\x23\\x45\\x67";
        // Store or use the address bytes as needed. Here, just a dummy operation.
        // No real storage or transaction required; this tests literal byte sequences.
    }

    /// Runner function to execute all above test functions
    public fun run_all_tests() {
        top_level_spec();
        log_debug_info();
        declare_address();
    }
}

//# run 0xA1B2::0xA1B2::run_all_tests