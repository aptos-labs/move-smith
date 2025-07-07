//# publish
module 0x1::test_module {
    use std::debug;

    // Top-level spec block: declare a function as a spec
    spec top_level_spec() {
        debug::print(&"Starting top-level spec");
    }

    // Function to log detailed debug info, including bytecode dump names
    public fun log_debug_info(name: &vector<u8>) {
        debug::print(name);
    }

    // A function demonstrating detailed debug logging with the source filename
    public fun dump_bytecode_with_filename() {
        // Simulate deriving the bytecode dump name from the source filename
        // For illustration, we use a placeholder filename string
        let filename: vector<u8> = b"source_file.move";
        debug::print(&filename);
    }

    // Literal address specifier with byte sequence
    // Define a constant with a literal address (simulate a byte sequence (0x1234))
    const ADDR_LITERAL: vector<u8> = vector[
        0x12, 0x34
    ];

    // Runner function to invoke debugger display
    public fun run_debugging() {
        log_debug_info(&b"test_module".to_vec());
        dump_bytecode_with_filename();
        debug::print(&ADDR_LITERAL);
    }
}

//# run 0x1::test_module::run_debugging --signers 0x1