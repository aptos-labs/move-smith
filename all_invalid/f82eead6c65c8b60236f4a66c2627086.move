//# publish
module 0xDEADBEEF::TestModule {
    // Top-level spec block
    spec {}
    
    // Function to log debug info and dump bytecode
    public fun log_debug_info_and_dump() {
        // Assuming debug logging is enabled
        // Log a message
        debug("Starting debug info and bytecode dump");
        
        // Display detailed info
        debug("TestModule: Debug info start");
        
        // Bytecode dump (simulate by printing module name and source file name)
        // In actual implementation, would dump bytecode or use debug features
        debug("Bytecode Dump for TestModule");
        
        // Log the source filename for detailed debug info
        debug("Source file: test_module.move");
    }
    
    // A runner to invoke the above function
    public fun run_debug() {
        log_debug_info_and_dump();
    }
}

//** Module publish **//
 //# publish

// Define a module for a function that receives a literal address specifier
//# publish
module 0xCAFEBABE::AddressSpec {
    // Function to demonstrate usage of literal address specifier
    public fun use_literal_address() {
        // Declare a literal address with a byte sequence
        let addr: address = b"\\xDE\\xAD\\xBE\\xEF"; // Hex sequence for DEADBEEF
        debug(addr);
    }
}

//** Module publish **//
 //# publish

// Script that triggers debug info log and bytecode dump, and uses address specifier
//# run 0xDEADBEEF::TestModule::run_debug
// Run the debug function to test logging and bytecode dump
//# run 0xCAFEBABE::AddressSpec::use_literal_address --signers 0xDEADBEEF
// Call the function that uses a literal address specifier