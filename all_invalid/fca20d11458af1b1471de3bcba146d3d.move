//# publish
module 0xDEADBEEF::DebugTests {
    // A simple spec block at the top level
    spec module_spec {
        // Function to log debug info about bytecode dump
        fun log_debug_info() {
            // This function would invoke debug logging when run
            // Here, in test, we simulate logging by printing debug info
            // (In actual Move, you'd use debug or log functions)
        }
    }

    // Spec block with nested definition to test nested specs
    spec nested_spec {
        fun nested_test() {
            // nested spec test
        }
    }

    // Function to test log with detailed info, including source file name
    public fun run_logs_with_debug() {
        // simulate logging debug info including source file name
        // In Move, you'd call debug! macro (or equivalent) here
        // But for testing, this can be an empty placeholder.
    }

    // Function that logs the bytecode dump name based on file name
    public fun log_source_info() {
        // Again, just a placeholder for actual debug log
    }

    // Runner function to trigger all above
    public fun run_all() {
        log_debug_info();
        nested_test();
        run_logs_with_debug();
        log_source_info();
    }
}

//# run 0xDEADBEEF::DebugTests::run_all

//# publish
module 0xCAFEBABE::LiteralAddresses {
    // Declare a literal address specifier with a byte sequence (0x1234)
    struct AddressSpecifier has copy, drop {
        bytes: vector<u8>,
    }

    // Function to set the address specifier with a byte sequence
    public fun create_address_specifier(): AddressSpecifier {
        let address_bytes = vector<u8> {0x12, 0x34};
        AddressSpecifier { bytes: address_bytes }
    }
}

//# run 0xCAFEBABE::LiteralAddresses::create_address_specifier
