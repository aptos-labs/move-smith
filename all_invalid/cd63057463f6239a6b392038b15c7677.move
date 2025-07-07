
//# publish
module 0xCAFE::UnusedParamAndBytes {

    // Function to test byte string literals and unused parameters
    public fun test_bytes_and_unused_params(_param: u64, _unused_param: u64) {
        // Use a byte string literal
        let bytes: vector<u8> = b"Test byte string literal\n";

        // Create a local variable from the byte string
        let _ = bytes;

        // The parameters are unused; prefix with _ to avoid warnings
    }
}



//# run 0xCAFE::UnusedParamAndBytes::test_bytes_and_unused_params --signers 0xBEEF --args 42u64 0u64



//# publish
module 0xCAFE::ExampleModule {

    // A runner function to invoke the previous function
    public fun run_test() {
        // Call the test function with placeholder values
        0xCAFE::UnusedParamAndBytes::test_bytes_and_unused_params(10, 20);
    }
}



//# run 0xCAFE::ExampleModule::run_test --signers 0xBEEF