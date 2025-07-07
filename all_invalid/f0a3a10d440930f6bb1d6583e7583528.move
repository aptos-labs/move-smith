//# publish
module 0xA550C3::test_optional_and_spec {
    use std::signer;
    use std::debug;

    /// Function with optional type annotation
    public fun optional_type_demo(opt_value: Option<u64>?): bool {
        // Check if optional value is present
        if (exists(opt_value)) {
            let value = Option.extract(opt_value);
            // Do something with value
            debug::print(&value);
            true
        } else {
            false
        }
    }

    /// Function to test specification correctness and pureness
    public fun check_specification() {
        // Specification: ensure the function is pure (no global state access)
        // Note: In Move, functions without side-effects are considered pure
        // We can add a spec for this function
        // (Note: This is illustrative; actual spec checks may require more tooling)
        // For demonstration, include a spec comment
        //:: Specification: optional_type_demo is pure
    }

    /// Function that groups multiple expressions into a block
    public fun group_expressions() {
        Block {
            let a = 10;
            let b = 20;
            let sum = a + b;
            debug::print(&sum);
            // Return the sum
            sum
        }
    }

    /// Runner function to invoke other functions
    public fun run_all() {
        // Call optional_type_demo with Some value
        optional_type_demo(Some(42));
        // Call optional_type_demo with None
        optional_type_demo(None);
        // Run the grouping expressions
        let result = group_expressions();
        debug::print(&result);
    }
}
//# run 0xA550C3::test_optional_and_spec::run_all