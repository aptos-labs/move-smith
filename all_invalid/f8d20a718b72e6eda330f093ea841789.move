//# publish
module 0xDEADBEEF::test_spec_features {

    // Top-level spec block: function-based spec
    public fun spec_function_feature() {
        // For illustration, no-op
    }

    // Spec block using a constant value with a spec filename (simulate source-based)
    public fun spec_with_spec_block() {
        // Just a placeholder to represent nested spec block inside functions
        // No actual syntax for nested specs, just functions simulating different spec parts
    }

    // Function to demonstrate debug logging with bytecode dump name derived from source file
    public fun debug_logging_with_bytecode_dumps() {
        // Assume debug logging is enabled in the environment
        // Log a message with source file info (simulate)
        // In actual Move, logging can be done via `debug` macro if enabled
        // For simulation, just include a comment
    }

    // Declare a literal address specifier with byte sequence
    public fun address_specifier_literal() {
        let addr: address = @0x12345678;
        // Use the address in some computation or just to ensure usage
    }

    // Function that demonstrates use of reference types to process borrowed data
    public fun process_borrowed_data(data: &vector<u8>) {
        // Read the data (borrowed)
        let length = data.len();
        // For demonstration, no modification
        // Just use data without taking ownership
        // e.g., check that length > 0
        assert!(length > 0, 42);
    }

    // Runner function to execute the above functions
    public fun run_all_specs() {
        spec_function_feature();
        spec_with_spec_block();
        debug_logging_with_bytecode_dumps();
        address_specifier_literal();
        // Prepare sample data for process_borrowed_data
        let sample_data = vector::empty<u8>();
        process_borrowed_data(&sample_data);
    }
}

//# run 0xDEADBEEF::test_spec_features::run_all_specs --signers 0x1 --args