//# publish
module 0xDEADBEEF::TransactionTestModule {
    use std::debug;

    // Top-level spec block as a function
    public entry fun spec_block_top_level() {
        debug::print(&"Starting top-level spec block");
    }

    // Log detailed debug information with bytecode dump name derived from source filename
    public fun log_debug_info() {
        // Assuming the source file is named 'transaction_test.move'
        let filename = "transaction_test.move";
        debug::print(&format!("Debug info for {}", filename));
    }

    // Declare a literal address specifier with a byte sequence
    public fun literal_address_spec() {
        // For demonstration, create an address from byte sequence (0x1234)
        let address_bytes = 0x1234u16; // Move does not support direct byte array literals, so using u16
        debug::print(&format!("Address specifier: (0x{:x})", address_bytes));
    }

    // Use statement to import a module or member
    use std::signer;

    // Define a "runner" function that calls other functions
    public fun run_all() {
        spec_block_top_level();
        log_debug_info();
        literal_address_spec();
    }
}

//# run 0xDEADBEEF::TransactionTestModule::run_all