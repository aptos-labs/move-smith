
//# publish
module 0xCAFE::TestFeatures {
    use std::signer;
    use std::assert;

    // Internal function to test access restrictions
    fun internal_helper() {
        // Do nothing
    }

    // Public function to call internal helper internally
    public fun call_internal_helper() {
        internal_helper();
    }

    // Script Entry Point for testing feature interactions
    public entry fun script_entry_interaction(s: signer) {
        // Call multiple module functions
        0xCAFE::MyModule::f1(2u8, true);
        0xCAFE::MyModule::f3(20u16);
        // Call internal function from within the module — allowed
        internal_helper();

        // Call the public wrapper that calls internal
        call_internal_helper();
    }

    // Script Entry Point for testing access restrictions
    public entry fun test_access_restrictions(s: signer) {
        // Expect this to fail if trying to call internal directly
        // but here, calling internal from inside module is fine
        // The following line is commented to avoid compilation failure in testing
        // internal_helper();

        // Call the wrapper that calls internal
        call_internal_helper();
    }

    // Implement source location annotation as a dummy attribute
    // attribute source_location("0xCAFE", 100)
    public entry fun source_location_test(s: signer) {
        // Nothing special, just for metadata testing
    }

    // Attach attribute to test metadata handling
    // attribute annotation_test("metadata")
    public entry fun annotation_test(s: signer) {
        // For test purposes, do nothing
    }

    // Declare typed bindings with optional types
    public fun test_type_bindings() {
        let a = 5u8; // No explicit type annotation, should infer u8
        let b: u16 = 10u16; // Explicit type annotation

        // Use variables to ensure types are enforced
        assert::assert(a == 5u8, 1);
        assert::assert(b == 10u16, 2);
    }

    // Wrapper to invoke all tests
    public fun run_all_tests(s: signer) {
        // Call the test functions
//# run
        script_entry_interaction(s);
        test_access_restrictions(s);
        source_location_test(s);
        annotation_test(s);
        test_type_bindings();
    }
}


//# run 0xCAFE::TestFeatures::run_all_tests --signers 0xBEEF
