//# publish
module 0xABC::TestModule {
    // Top-level spec block as a function
    public fun top_level_spec() {
        // noop
    }

    // Function to test address specifier and match call
    public fun test_address_and_match() {
        let addr_literal: address = 0x1234; // Address literal specifier

        // Call match with literals and address
        match(1, "test", addr_literal);
    }

    // Runner function to execute test_address_and_match
    public fun run_tests() {
        Self::test_address_and_match();
    }
}

//# run 0xABC::TestModule::run_tests