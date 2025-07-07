//# publish
module 0x1::TestModule {
    // Top-level spec block example: define a function with nested specs
    public fun top_level_spec() {
        // Nested spec block as a comment for clarity (not executable)
        // spec {
        //     description: "This is a top-level spec block"
        // }
    }

    // Function to enable debug logging and print bytecode dump name
    public fun debug_log_bytecode(dump_name: vector<u8>) {
        // For demonstration, assume this logs debug info when enabled
        // The actual logging would depend on the environment
        // e.g., using a debug macro or built-in logging
    }

    // Runner function to invoke debug info with a source-derived dump name
    public fun run_debug_dump() {
        // Example: derive dump name from source file name
        // In real test, this might be auto-generated; here, we hardcode for illustration
        let dump_name = b"test_source.move";
        Self::debug_log_bytecode(dump_name);
    }
}

// //# run 0x1::TestModule::run_debug_dump

//# publish
module 0x2::DebugTest {
    use std::debug;

    // Function to emit detailed debug info and log bytecode dump name
    public fun emit_debug_info() {
        // Enable debug logging
        debug::print("Debug info enabled");

        // Log detailed debug info (mocked with print statements)
        debug::print("Starting detailed debug info...");

        // Simulate debug info about bytecode dump, derived from source filename
        // e.g., source file: "demo_test.move" => dump name "demo_test"
        let dump_name = b"demo_test";

        // Log the dump name (as bytes)
        debug::print(b"Bytecode dump name: ", dump_name);
    }

    // Function that calls emit_debug_info
    public fun run_debug_emitter() {
        Self::emit_debug_info();
    }
}

// //# run 0x2::DebugTest::run_debug_emitter

//# publish
module 0x3::LiteralAddressDemo {
    // Declare a literal address specifier with a byte sequence
    // Since Move does not directly support byte sequence literals, use a vector of u8
    static ADDRESS: vector<u8> = b"(0x1234)";

    // Function to return the address as bytes for testing
    public fun get_literal_address(): vector<u8> {
        Self::ADDRESS
    }

    // Runner function for testing
    public fun run_literal_address() {
        let addr = Self::get_literal_address();
        // In a real test, we might log or assert the value
        // Here, we just invoke debug print (assuming debug macro)
        // For demonstration, calling print to show address
        // For the purpose of this test, comment out (or replace with debug macro if available)
        // debug::print("Literal address bytes: ", addr);
    }
}

// //# run 0x3::LiteralAddressDemo::run_literal_address