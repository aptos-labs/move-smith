//# publish
module 0x1::test_module {
    use std::debug;

    /// Top-level spec block as a function
    spec foo {
        /**
         * Log debug info with a bytecode dump name derived from source filename.
         * Assuming debugging prints the filename, we simulate that.
         */
        public fun log_debug_info() {
            debug::print("[Debug] Loading module from source_move_test.move");
        }
    }

    /// Declaration of a literal address specifier using a byte sequence
    // We define a constant representing a byte sequence hex literal as spec.
    public const ADDRESS_LITERAL: vector<u8> = vector::empty<u8>();

    /// Runner function for logs
    public fun run_log_debug() {
        // Log debug info, simulate debug output for bytecode dump name.
        debug::print("[Debug] Bytecode dump: source_move_test.move");
        // Call the spec block function
        Self::log_debug_info();
    }

    //# run 0xDEADBEEF::test_module::run_log_debug
    /// Test move function with addition and abort within expression
    public fun test_add_and_abort() {
        // Example of triggering an abort within an expression
        let _result = if (true) {
            // Perform addition
            let sum = 2 + 3;
            // Trigger abort intentionally if sum equals 5
            if (sum == 5) {
                abort!("Triggered abort for testing");
            }
            sum
        } else {
            0
        };
    }

    //# run 0xDEADBEEF::test_module::test_add_and_abort
}