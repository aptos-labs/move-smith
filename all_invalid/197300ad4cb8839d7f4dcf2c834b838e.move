//# publish
module 0x1::TestModule {
    // Top-level spec block as a function
    public fun top_level_spec() {
        // Placeholder for spec logic
    }

    // Spec block declared as a struct
    struct SpecStruct {
        dummy: bool,
    }

    // Function to test address specifier with byte sequence literal
    public fun declare_address_literal(addr: address) {
        // No-op; used for testing address literal
    }

    // Function to test use statements with aliasing
    use 0x1::OtherModule as OM;

    public fun use_statement_test() {
        // Call a function from the alias
        OM::other_function();
    }

    // Runner function to execute tests
    public fun run_tests() {
        top_level_spec();
        declare_address_literal(0x1234); // testing address literal (0x1234)
        use_statement_test();
    }
}

//# run 0x1::TestModule::run_tests

//# publish
module 0x1::OtherModule {
    public fun other_function() {
        // dummy function to test use statement
    }
}

//# publish
// No additional modules needed; we include all in above modules