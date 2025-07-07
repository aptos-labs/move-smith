//# publish
module 0x1::debug_logging_test {
    use std::debug;
    use std::signer;
    use std::vector;

    /// Function to enable debug logging and dump bytecode names from source file
    public fun run_debug_logging() {
        // Enable debug logging
        // Note: In actual tests, enabling debug might require env setup; assume it's enabled here.
        debug::print(&"Starting debug logging test");
        
        // Get the current module's source file name (simulate by providing a name)
        // In practice, this might be derived from compile info; here, use a placeholder
        let source_file_name = "debug_logging_test.move";
        // Dump the bytecode section names (simulate by printing the source file name)
        debug::print(&format!("Bytecode dump names from source: {}", source_file_name));
    }
}

//# run 0x1::debug_logging_test::run_debug_logging

//# publish
module 0x2::literal_address {
    use std::debug;

    /// Function demonstrating declaration of a literal address with a byte sequence
    public fun declare_literal_address() {
        // Declare an address as a literal byte sequence (simulated as an array)
        let addr_bytes = vector::empty<u8>();
        vector::push_back(&mut addr_bytes, 0x12);
        vector::push_back(&mut addr_bytes, 0x34);
        vector::push_back(&mut addr_bytes, 0x56);
        vector::push_back(&mut addr_bytes, 0x78);

        // For illustration purposes, represent the address as a hex string
        let addr_str = "0x12_34_56_78";

        // Log the address representation
        debug::print(&format!("Literal address declared: {}", addr_str));
    }
}

//# run 0x2::literal_address::declare_literal_address

//# publish
module 0x3::failure_location {
    use std::debug;

    /// This function intentionally triggers an expected failure with location info
    #[expected_failure(location = "invalid_pointer_error")]
    public fun trigger_failure() {
        // Simulate an invalid operation that causes failure
        // For example, attempt to access an invalid index in a vector
        let v = vector::empty<u64>();
        // This will cause failure: index out of bounds
        let _val = *vector::borrow(&v, 0);
        // Note: The actual failure will occur at runtime
    }
}

//# run 0x3::failure_location::trigger_failure --signers 0x0 --args

//# publish
module 0x4::runner {
    use std::debug;
    use std::signer;

    public fun run_all_tests() {
        // Call debug logging test
        0x1::debug_logging_test::run_debug_logging();

        // Call literal address declaration test
        0x2::literal_address::declare_literal_address();

        // Call failure trigger, expecting failure with location info
        // Normally, we wouldn't catch this; assume test environment handles failure expectations
        0x3::failure_location::trigger_failure();
    }
}

//# run 0x4::runner::run_all_tests --signers 0x0