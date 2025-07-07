//# publish
module 0x1::TestModule {
    use std::debug;
    use std::vector;

    // Top-level spec block that defines functions and other specifications
    public fun spec_block() {
        debug::print("[Spec] Starting spec block...");
        // You can add more spec-related logic here
    }

    // Function to log detailed debug information
    public fun log_debug_info(source_name: &string) {
        debug::print(&string_ascii!("[Debug] Bytecode dump for source: ", source_name));
    }

    // Function to declare a literal address specifier with byte sequence
    public fun address_literal_specifier() {
        let addr_bytes = vector::empty<u8>();
        // Example byte sequence
        vector::push_back(&mut addr_bytes, 0x12);
        vector::push_back(&mut addr_bytes, 0x34);
        // Log the byte sequence as hex string
        debug::print(&string::concat("[Address Specifier] Byte sequence: ", address_bytes));
    }

    // Runner function to execute all tests
    public fun run_all() {
        spec_block();
        log_debug_info("test_source.move");
        address_literal_specifier();
    }
}

 //# run 0x1::TestModule::run_all

// Example script that exercises the module's features
//# run
script {
    use 0x1::TestModule;

    fun main() {
        // Call the spec block
        TestModule.spec_block();

        // Log detailed debug info with source name
        TestModule.log_debug_info("transaction_test_source.move");

        // Declare literal address specifier
        TestModule.address_literal_specifier();

        // Optionally, run the runner function
        TestModule.run_all();
    }
}