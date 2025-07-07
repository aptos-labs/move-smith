
//# publish
module 0xCAFE::TestAdvancedFeatures {
    use std::signer;
    use std::vector;
    use std::option;
    use std::debug;

    // --- Internal function with restricted access ---
    // (simulate 'internal' by making it private; accessible only within this module)
    fun internal_log_access(s: signer, message: vector<u8>) {
        // Imagine this logs message internally; for test, just a placeholder
        debug::print(&message);
    }

    // --- Deprecated API example ---
    // deprecated]
    public fun deprecated_function() {
        // No-op, just to trigger warning
    }

    // --- Entry point for testing module functions ---
    public fun run_tests() {
        // Call entry points to test their correctness
        Self::test_entry_points();
        // Call function with block expressions on both sides
        Self::test_block_expression_comparison();
        // Call function that uses deprecated item
        Self::test_deprecated_annotation();
        // Log something to test environment variable handling
        Self::test_logging();
        // Test access restrictions
        Self::test_access_control();
    }

    public fun test_entry_points() {
        // Call a public function (simulating an entry point)
        let res = f1(10u8, true);
        // Verify the flow: no assertions needed, just call
        // Call function with match
        let e = E::V2(3, 4);
        let res_match = match (e) {
            E::V1 => 1,
            E::V2(x, y) => x + y,
            E::V3 { a: _ } => 0,
        };
        // Call function that returns tuple
        let (a, b) = f2(5);
        // Call nested vector usage
        example_vector_usage();
    }

    public fun test_block_expression_comparison() {
        // Evaluate blocks on both sides of comparison
        let left = {
            let temp = 3u64;
            temp + 2
        };
        let right = {
            let temp = 4u64;
            temp + 1
        };
        let is_equal = if (left == right) { true } else { false };
        // No assertion, just run
        is_equal;
    }

    public fun test_deprecated_annotation() {
        // Call deprecated function to verify warning
        deprecated_function();
    }

    public fun test_logging() {
        // Store environment variable pointing to log file name (simulate)
        // Log a message
        let log_msg = b"Move test logging event".to_owned();
        // Call internal log function (simulate environment logging)
        internal_log_access(signer::address_of(&signer::borrow_self()), log_msg);
    }

    public fun test_access_control() {
        // Attempt to call internal log function from external code
        // This should be forbidden in real cases, but for test, we call directly
        internal_log_access(signer::address_of(&signer::borrow_self()), b"Test access".to_owned());
    }
}


// Featurres:
// b70ccb6e356eebb5b3735f5f76cd5273: Write script entry points in Move modules
// 56a82df6b40d543d56a4081aa298c444: Set up file logging by specifying a file name from the environment variable.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// 79d02bcb625237d3284e70591d45763e: Test that a block expression on the left side of a comparison operator is properly evaluated independently from the block on the right side.
// a2d7fbb8193d7979e093ba1c6ea49a06: Annotate module members with deprecated annotations
