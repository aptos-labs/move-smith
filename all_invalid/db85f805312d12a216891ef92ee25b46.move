//# publish
module 0x1::TestModule {

    /// Top-level spec block: defines a resource and a function to initialize it.
    spec module {
        // Resource to store debug info
        resource struct DebugInfo {
            info: vector<u8>,
        }

        /// Initialize debug info with a message
        public fun init_debug_info(account: &signer, message: vector<u8>) {
            move_to(account, DebugInfo { info: message });
        }

        /// Function to dump the bytecode name for a source file (simulate debug logging)
        public fun dump_bytecode_name(name: vector<u8>) {
            // For testing purposes, simulate bytecode dump name logging
            // In real case, might log or record name
            // Here, just a no-op or dummy store
            // No-op for placeholder
        }

        /// Set debug logging flag
        static DEBUG_ENABLED: bool = true;

        /// Helper to log debug info if enabled
        public fun log_debug(message: vector<u8>) {
            // Checks if debug is enabled
            if (Self::DEBUG_ENABLED) {
                // For demonstration, call dump_bytecode_name with message
                Self::dump_bytecode_name(message);
            }
        }
    }

    /// A runner function that demonstrates debug info, spec declarations, and address literals
    public fun run_all() {
        // For simplicity, pretend that the source filename is 'test_move.move'
        // and simulate logging its name with special literal address

        // Example: Log the source filename (simulate bytecode dump name)
        let filename = b"test_move.move";

        // Convert filename to a vector<u8>
        // Since in Move, byte literals are vector<u8>
        // Call debug dump name
        Self::dump_bytecode_name(filename);

        // Create a dummy address specifier with a literal byte sequence (e.g., (0x1234))
        let address_literal = (0x1234u16);
        // Normally, this would be used in a transaction or function call

        // Call the debug log function with a message
        Self::log_debug(filename);

        // Initialize debug info resource
        let account = Signer::address_of(&signer);
        Self::init_debug_info(&signer, filename);
    }

}

//# run 0x1::TestModule::run_all