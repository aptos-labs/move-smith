//# publish
module 0xA550::TestModule {
    use std::debug;
    use move_std::string;
    use move_std::address;

    // Top-level spec block as a function
    public fun top_level_spec() {
        debug::print(&string::utf8(b"Top-level spec block executed"));
    }

    // Function to log a debug message with bytecode dump info
    public fun log_debug_with_dump() {
        // Assume this function is called during the test
        debug::print(&string::utf8(b"Debug info with bytecode dump"));
        debug::print(&string::utf8(b"Bytecode dump name: dump_name_from_source"));
    }

    // Declare a literal address specifier with a byte sequence
    public fun declare_literal_address() {
        let literal_address = address::from_bytes(b"\x12\x34");
        debug::print(&string::utf8(b"Declared literal address with bytes: 0x12 0x34"));
        // Use the address in some way
        debug::print(&address::to_string(&literal_address));
    }

    // Runner function to exercise module functionality
    public fun run_all() {
        top_level_spec();
        log_debug_with_dump();
        declare_literal_address();
    }
}

//# run 0xA550::TestModule::run_all

//# publish
module 0xA550::NestedSpec {
    use std::debug;

    // Including a nested spec block as a function
    public fun nested_spec_block() {
        debug::print(&string::utf8(b"Nested spec block executed"));
    }

    // Function to perform complex logging
    public fun debug_logging() {
        debug::print(&string::utf8(b"Debug logs with detailed info"));
    }

    // Routine that calls nested spec functions
    public fun run_nested_specs() {
        nested_spec_block();
        debug_logging();
    }
}

//# run 0xA550::NestedSpec::run_nested_specs