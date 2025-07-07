
//# publish
module 0xCAFE::TestModule {
    use std::debug;

    // Function to test move command and module identification
    public fun test_move_and_module_info() {
        // Creating a value to move
        let value = 42u64;

        // Moving the value into a new variable using 'move' keyword
        move value_x = value;

        // Retrieve the module's identifier (simulate by getting module info)
        // Move does not directly support reflection, so we just log the module address and name
        debug::print(b"[Test] Module address: 0xCAFE");
        debug::print(b"[Test] Module name: TestModule");
    }
}



//# run 0xDEADBEEF::TestModule::test_move_and_module_info --signers 0xCAFE



//# publish
module 0xCAFE::Diagnostic {
    use std::debug;

    // Function to set environment variable controlling diagnostic message color output
    public fun set_diag_color(output_color: bool) {
        // This is a placeholder for setting environment variable based on input
        // In actual tests, this might interface with the VM or environment
        debug::print(b"Set diagnostic color output to:");
        if (output_color) {
            debug::print(b"true");
        } else {
            debug::print(b"false");
        }
    }
}



//# run 0xDEADBEEF::Diagnostic::set_diag_color --args true --signers 0xCAFE