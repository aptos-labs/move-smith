//# publish
module 0x1::TestModule {
    use std::debug;
    use std::string;

    // Top-level spec block as a function to encapsulate test scenario
    public fun spec_test_top_level() {
        debug::emit_event(&string::utf8(b"Starting top-level spec test"), 0);
        // Logging debug info with a bytecode dump name derived from the source file
        debug::print(&string::utf8(b"Debug: Loading module 0x1::TestModule"));

        // Declare a literal address specifier
        let addr: address = (0x1234);
        debug::print(&string::utf8(b"Literal address declared: 0x1234"));

        // Call an internal function to demonstrate nested specs
        self::run_inner_spec(addr);
    }

    // Inner spec to test nested spec blocks
    public fun run_inner_spec(addr: address) {
        debug::emit_event(&string::utf8(b"Running inner spec for address: 0x"), 0);
        debug::print(&string::utf8(b"Address: 0x"));
        debug::print(&string::utf8(&core::b32::to_string(addr)));

        // Log detailed debug info, simulating bytecode dump name
        debug::print(&string::utf8(b"Debug: Bytecode dump for run_inner_spec"));
    }
}

//# run
main() {
    // Call the top-level spec function to execute the test
    0x1::TestModule::spec_test_top_level();
}