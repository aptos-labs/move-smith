//# publish
module 0x1::test_module {

    /// Top-level spec block as a function
    public fun top_level_spec() {
        // no-op
    }

    /// Spec block defined as a struct with a function
    struct SpecStruct has copy, drop, store {
        value: u64,
    }

    public fun spec_struct_function() {
        // no-op
    }

    // Function to log debug info, enabled if debug logging is supported
    public fun log_debug_info(name: vector<u8>) {
        // Placeholder for debug logging; in actual tests, this would trigger debug logs
        // e.g., debug::print(&name);
    }

    // Function to demonstrate address specifier
    public fun declare_literal_address() {
        let addr: address = (0x1234);
        // use addr in some way
    }

    // Function to run lambda lifting
    public fun run_lambda_lifting() {
        let f = || {
            // inner lambda
            // Place any computations to be lifted here
        };
        f();
    }

    /// Runner function to exercise various features
    public fun run_all() {
        top_level_spec();
        spec_struct_function();
        log_debug_info(b"debug_log");
        declare_literal_address();
        run_lambda_lifting();
    }
}
//# run 0x1::test_module::run_all --signers 0x1