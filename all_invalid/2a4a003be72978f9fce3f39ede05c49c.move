//# publish
module 0x1::test_module {
    /// Top-level spec block as a function
    public fun top_level_spec() {
        // No implementation; just a placeholder to test spec declaration
    }

    /// Log detailed debug info, including bytecode dump names
    public fun log_debug_info() {
        // for demonstration, we're simulating a debug log
        let debug_message = "Debug: Bytecode dump based on source file 'test.move'";
        // In actual Move, logging might involve emit_event or similar; here we just simulate.
        // move can't explicitly print, but assume debug mode enables logs.
        move_shared::debug_module::print(debug_message);
    }

    /// Declare a literal address specifier with a byte sequence
    public fun declare_address_literal() {
        let address_literal: vector<u8> = vector {
            // (0x1234) as byte sequence
            0x12, 0x34
        };
        // Use address_literal for further logic if needed
        // For test purposes, we could store or return it
        return address_literal;
    }

    /// Runner function to exercise the above features
    public fun run_all() {
        top_level_spec();
        log_debug_info();
        declare_address_literal();
    }
}

//# run 0x1::test_module::run_all

//# publish
module 0x2::dependent_module {
    /// A simple function to test module call
    public fun helper_function() {
        // Placeholder
    }
}

//# run 0x2::dependent_module::helper_function --signers 0x1

//# publish
script {
    // Script to invoke the module's functions that tests features
    fun main() {
        // Call the runner function in test_module to trigger all tests
        0x1::test_module::run_all();
    }
}