//# publish
module 0x1::debug_logging_test {
    /// This struct is used for optional debug info
    struct DebugInfo has copy, drop, store {
        message: vector<u8>,
    }

    /// Function to log debug info with detailed bytecode dump name
    public fun log_debug_info(info: &DebugInfo) {
        // Placeholder for actual debug logging
        // In real test, this would trigger debug logs
        // For simulation, we just abort or no-op
        // Here, assume a debug log
    }

    /// Top-level spec block: main test function
    public fun run_all_tests() {
        // Log debug info with filename-based name
        let debug_name = b"transactional_test_source.move"; // Source filename
        let debug_info = DebugInfo { message: debug_name };
        log_debug_info(&debug_info);
        
        // Include feature: declare a top-level spec block
        spec {
            // Inside spec, perform various actions
            
            // Log detailed info with bytecode dump name
            let filename_bytes = b"transactional_test_source.move";
            let info = DebugInfo { message: filename_bytes };
            log_debug_info(&info);
        }
        
        // Demonstrate literal address specifier with byte sequence
        let addr_bytes: vector<u8> = move {
            // Example byte sequence, e.g., 0x12 0x34
            let mut v = vector::empty<u8>();
            vector::push_back(&mut v, 0x12);
            vector::push_back(&mut v, 0x34);
            v
        };
        // Using the literal address specifier '(0x1234)'
        let literal_address = move {
            // In actual code, push the byte sequence as an address or comment
            // For testing, just print or log the bytes
            // (Placeholder: no real print, just a comment)
        };
    }
}


 //# run
 /// Run the main test function to exercise compiler and VM.
 //# run 0x1::debug_logging_test::run_all_tests