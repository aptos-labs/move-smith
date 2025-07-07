//# publish
module 0x1::test_spec_blocks {
    use std::log;
    use std::bytearray;

    // Spec block 1: Top-level spec with a simple function
    spec module {
        // Function to log debug info and simulate spec decorations
        public fun log_spec_top_level() {
            // Log a message indicating debug info dump
            log::info(&"Debug info dump: bytecode_from_source_file.rs");
        }
    }

    // Spec block 2: Declare literal address specifier with byte sequence
    spec address_spec {
        // Define a constant with a literal byte sequence
        public const LITERAL_ADDRESS: address = address_from_bytes([0x12, 0x34]);
        // Function to log the address (simulate)
        public fun log_address() {
            log::info(&"Address spec: " ++ bytearray::to_string(&bytearray::from_bytes(&LITERAL_ADDRESS.bytes())));
        }
    }

    // Spec block 3: Feature flag simulation for AST simplification
    spec feature_flag {
        // Assume 'AST_SIMPLIFY' experiment is active
        // No code elimination: simulate by defining functions
        public fun ast_simplify_behavior() {
            log::info(&"AST_SIMPLIFY experiment active: no code elimination");
        }
    }

    // Runner function to execute all spec logs
    public fun run_all_specs() {
        log_spec_top_level();
        address_spec::log_address();
        feature_flag::ast_simplify_behavior();
    }
}

//# run 0x1::test_spec_blocks::run_all_specs