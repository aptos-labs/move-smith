//# publish
module 0xA11C::DebugLoggingTest {
    use std::debug;
    use std::vector;

    // Function to log debug info with detailed message and bytecode dump name
    public fun log_debug_message(message: vector<u8>) {
        // Log the message as debug info
        debug::print(&message);
        // Log additional debug info including a bytecode dump name for traceability
        debug::print(&vector::single_bytes(0x31)); // '1' as a marker
        debug::print(&vector::single_bytes(0x32)); // '2' as a marker

        // Simulate referencing a bytecode dump name derived from source file name
        // (In practice, this might be a constant string or filename hash)
        let dump_name = b"DebugLoggingTest.move";
        debug::print(dump_name);
    }

    // Spec block with top-level definition capturing address literal
    spec { 
        // Literal address specifier with byte sequence
        let address_literal: vector<u8> = vector::from_bytes(&(0x12, 0x34));

        // Spec function testing top-level features
        public fun top_level_spec() {
            // Log a message with debug info
            let message = vector::single_bytes(0x48); // 'H'
            log_debug_message(message);
        }
    }

    // Main runner function to execute the top-level spec
    public fun run_all() {
        // Call the top-level spec function
        Self::top_level_spec();
    }
}

//# run 0xA11C::DebugLoggingTest::run_all --signers 0xA11C