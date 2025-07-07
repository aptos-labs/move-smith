//# publish
module 0x1::debug {
    // Basic debug functions (simulate detailed debug logging)
    public fun enable() {
        // Enable debug (mocked)
    }

    public fun dump_bytecode(name: vector<u8>) {
        // Mock dump: print the name as debug info
        // In an actual test, this could push to a debug buffer
    }
}

//# publish
module 0x2::top_level_spec {
    use 0x1::debug;

    // Spec block: top-level function to demonstrate feature inclusion
    public fun top_level_feature() {
        // Log debug info for top-level spec feature
        debug::dump_bytecode(b"top_level_spec.move");
    }

    // Spec block: nested definition (simulate with functions)
    public fun nested_spec_feature() {
        debug::dump_bytecode(b"nested_spec.move");
    }

    // Function to test detailed debug info and bytecode logs
    public fun run_all_specs() {
        top_level_feature();
        nested_spec_feature();
    }
}

//# publish
module 0x3::bytecode_debug {
    use 0x1::debug;

    // Function to log detailed debug info including derived bytecode filename
    public fun log_debug_info(filename: vector<u8>) {
        // Dump the filename to debug log
        debug::dump_bytecode(filename);
    }
}

//# publish
module 0x4::literal_address {
    use 0x1::debug;

    // Function to demonstrate literal address specifier
    public fun log_literal_address() {
        // Declare literal address with a byte value (e.g., 0x1234)
        let literal_addr: vector<u8> = b"(0x1234)";
        debug::dump_bytecode(literal_addr);
    }
}

//# publish
module 0x5::test_runner {
    use 0x2::top_level_spec;
    use 0x3::bytecode_debug;
    use 0x4::literal_address;

    // Runner function to execute all above features
    public fun run_tests() {
        // Run top level spec functions
        top_level_spec::top_level_feature();
        top_level_spec::nested_spec_feature();

        // Log detailed debug info with source filename
        let filename: vector<u8> = b"top_level_spec.move";
        bytecode_debug::log_debug_info(filename);

        // Log debug info about bytecode dump filename
        bytecode_debug::log_debug_info(b"bytecode_debug.move");

        // Log debug info for literal address specifier
        literal_address::log_literal_address();
    }
}

//# run 0x5::test_runner::run_tests --signers 0x0