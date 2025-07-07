//# publish
module 0x1::TestModule {
    use std::debug;

    // Top-level spec block: define a function with detailed debug logging
    spec fun top_level_spec() {
        // Enable debug logging for detailed info
        debug::print("[TestModule] Starting top_level_spec");
        
        // Declare a literal address specifier with a byte sequence
        let addr_literal: vector<u8> = vec![0x12, 0x34, 0x56, 0x78];

        // Log the bytecode dump name derived from source file
        debug::print("[TestModule] Bytecode dump: tests/test_module.move");

        // Define a nested spec to check function behavior
        spec fun internal_check() {
            // Activate AST filtering for verification
            // -- filter: function_name: internal_check
            debug::print("[TestModule] Filtering AST for internal_check");
        }

        // Apply pragmas to guide verification
        // pragma verify
        debug::print("[TestModule] Applying verify pragma");
    }

    // Function inside module to be invoked during test
    public fun run_spec() {
        debug::print("[TestModule] Running top_level_spec");
        top_level_spec();
    }
}

//# run 0x1::TestModule::run_spec --signers 0x1