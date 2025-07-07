//# publish
module 0x1::TestModule {
    use std::debug;
    use std::string;

    // Spec block: Top-level spec function
    public fun top_level_spec() {
        debug::print(&string::utf8(b"Starting top-level spec test"));

        // Create a literal address specifier
        let addr_spec = (0x1234);
        debug::print(&string::concat(
            &string::utf8(b"Address specifier: "),
            &string::hex(&addr_spec)
        ));

        // Log a debug message with a detailed bytecode dump name
        // Assuming source file name is "test.move"
        debug::print(&string::utf8(b"Debug info: Bytecode dump for test.move"));

        // Call an internal test function
        Self::internal_test();
    }

    // An internal test function to exercise more compiler/VM features
    fun internal_test() {
        debug::print(&string::utf8(b"Running internal test function"));

        // Log detailed debug information about bytecode dump name
        debug::print(&string::utf8(b"Debug info: Bytecode dump for internal_test"));

        // Example of declaring a literal address specifier in a variable
        let addr = (0xABCD);
        debug::print(&string::concat(
            &string::utf8(b"Internal test address: "),
            &string::hex(&addr)
        ));
    }

    // Runner function to execute the top-level spec
    public fun run_tests() {
        top_level_spec();
    }
}

//# run 0x1::TestModule::run_tests