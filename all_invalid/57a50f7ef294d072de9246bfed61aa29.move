
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
        debug::print("[Test] Module address: 0xCAFE");
        debug::print("[Test] Module name: TestModule");
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
        debug::print("Set diagnostic color output to:");
        if (output_color) {
            debug::print("true");
        } else {
            debug::print("false");
        }
    }
}


//# run 0xDEADBEEF::Diagnostic::set_diag_color --args true --signers 0xCAFE

// Featurres:
// 80fa296d3cb0b60df8732396c95c08e7: Write 'move x' instead of 'move(x)' to specify a move operation.
// a9bf1eb4cc5818ed2292a8a12504cc12: Retrieve the module's identifier (address and name) after deserialization.
// d7aee01c7ef590d18539522f4aef85aa: Use environment variables to control diagnostic message color output.
