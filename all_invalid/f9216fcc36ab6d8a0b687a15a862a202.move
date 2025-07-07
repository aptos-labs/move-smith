//# publish
module 0x1::TestModule {
    use std::debug;
    use std::vector;

    // A top-level spec block, could be a function or data structure
    spec () {
        // Just a placeholder for spec syntax, can be empty or contain tests
    }

    // Function to log detailed debug info about bytecode dump
    public fun log_bytecode_dump() {
        // Assume debug_log supports printing strings; mimic detailed dump
        debug::print(&"Starting bytecode dump for source: source_move_file.move");
        // Simulate dump name derived from source file name
        debug::print(&"Dump name: source_move_file.bytecode");
    }

    // Function to log detailed info including literal address
    public fun log_address_info(addr: address) {
        debug::print(&"Literal address specified: ");
        debug::print(&Vector::stringify(&addr));
        debug::print(&"Address in hex: 0x");
        debug::print(&Vector::hex_string(&address::to_bytes(&addr)));
    }

    // Runner function to exercise the features
    public fun run_tests() {
        // Log debug info with source file name
        Self::log_bytecode_dump();

        // Declare a literal address specifier (e.g., (0x1234))
        let address_literal = @0x1234;
        Self::log_address_info(address_literal);
    }
}

//# run 0x1::TestModule::run_tests