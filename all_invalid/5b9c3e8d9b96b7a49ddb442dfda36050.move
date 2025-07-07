//# publish
module 0x1::test_module {

    /// Top-level spec block as a function.
    public fun top_level_spec() {
        // Intentionally left blank
    }

    /// Another spec block with detailed debug info.
    public fun debug_spec() {
        // Log debug info; assuming a debug macro or print is available
        // Since Move doesn't have built-in print, this is conceptual.
        // In real tests, debug info may be logged via special instructions or flags.
        // For the purposes of this test, we assume debug macro:
        // debug!({"Dumping bytecode for source: move/test_move_tests.move"});
    }

    /// Declare a literal address specifier with a byte sequence.
    // Usually, addresses are specified as 0x..., but to simulate byte sequence, we can define a constant.
    const ADDRESS_BYTES: vector<u8> = vector::from_bytes(b"0x1234");

    /// Attribute with apply syntax to specify attributes without parameters.
    #[apply no_fail]
    public fun attribute_no_fail() {
        // Function with attribute signaling expected failure.
    }

    /// Combined attribute with apply syntax.
    #[apply expected_failure]
    public fun attribute_expected_failure() {
        // Function expected to fail.
    }

    /// Runner function to test the module.
    public fun run_all() {
        // Call spec functions
        Self::top_level_spec();
        Self::debug_spec();

        // Call attribute functions
        Self::attribute_no_fail();
        Self::attribute_expected_failure();

        // Use the declared address bytes in some way (simulate usage)
        let addr_bytes = Self::ADDRESS_BYTES;
        // (No actual assertion; just exercise bytecode handling)
    }
}

//# run 0xDEAD::test_module::run_all