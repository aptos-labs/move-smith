//# publish
module 0x1::TestModule {
    use std::debug;

    // Top-level spec block: a function acting as a spec
    public fun run_spec() {
        // This can be expanded with actual spec logic if needed
    }

    // Function to emit a debug log with bytecode dump name derived from source file
    public fun log_debug_info() {
        // Log a message including the bytecode dump name
        debug::print(&"Debug: Bytecode dump name: test_module.move");
    }

    // Function to demonstrate declaring a literal address specifier with a byte sequence
    public fun declare_address_literal() {
        // Declare a literal address with a specific byte sequence (0x1234)
        let addr: address = address::from_bytes(b"\x12\x34");
        debug::print(&"Address declared with bytes: 0x1234");
    }

    // Runner function to invoke internal test functions
    public fun run_all_tests() {
        log_debug_info();
        declare_address_literal();
    }
}

// The above module is to be published
//# publish

//# run 0x1::TestModule::run_all_tests --signers 0x0 :: 0x1::TestModule::run_all_tests