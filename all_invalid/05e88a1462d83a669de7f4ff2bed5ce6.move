
//# publish
module 0xCAFE::UnusedParamAndBytes {

    // Function to test byte string literals and unused parameters
    public fun test_bytes_and_unused_params(param: u64, unused_param: u64) {
        // Use a byte string literal
        let bytes: vector<u8> = b"Test byte string literal\n";

        // Create a local variable from the byte string
        let _ = bytes;

        // The unused_param is intentionally not used to test detection of unused variables
        // The param is also unused, which should generate a warning or error during compilation if unused detection is strict
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

// Featurres:
// 5f2a00cdcd250456968fb75d1c359440: Use byte string literals to include raw byte sequences within your code.
// 6b06ced8de2f19493c290b196338380a: Detect and identify unused parameters and variables within a function.
// 1cce47bbf03671922de1f2945e40ea6f: Use address variables without assigned values during compilation to generate an error message.
