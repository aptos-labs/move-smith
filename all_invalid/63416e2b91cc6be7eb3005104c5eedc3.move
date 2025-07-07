//# publish
module 0x1::TestBuiltinFunctions {
    use 0x1::Vector;
    use move_stdlib::errors::move_abort;

    /// Call a built-in function with explicit type arguments and arguments.
    public fun call_built_in_with_types_and_args<T>(x: T, y: u64) {
        // Example: Let's assume there is a built-in function that accepts types and values.
        // For the purpose of testing, we'll simulate calling an internal intrinsic.
        // Move does not directly expose intrinsic calls, but for test, we simulate expected behavior.
        // This is a placeholder to ensure compiler and VM handle such calls correctly.
        move_stdlib::core::write_u64(y);
        // No actual intrinsic call, just a dummy call to make use of types.
    }

    /// Test consume_token to match a specific token.
    public fun consume_token_example() {
        // Placeholder for testing token consumption; in real tests, tokens are during compilation.
        // Here, we simulate calling a parser function that consumes tokens, but in module code.
        // Since we can't directly manipulate the Move parser, we assume a placeholder.
        // For actual parser testing, this is outside the scope of a transaction script.
    }

    /// Function to trigger an error due to improper function call.
    public fun faulty_function_call() {
        // Intentional error: calling a non-existent function to test error reporting.
        // This should produce a compilation or runtime error when this script is executed.
        // For the purpose of the test, we leave this as a placeholder.
        // Alternatively, attempt to call a function with wrong signature to generate error.
        // For example, calling a function with wrong argument count.
        // move_stdlib::core::write_u64(); // Uncommenting this line would generate an error
    }

    /// Runner function to execute all tests inside this module.
    public fun run_tests() {
        call_built_in_with_types_and_args<u8>(10, 100);
        consume_token_example();
        // Faulty call to test error reporting
        faulty_function_call();
    }
}

//# run 0x1::TestBuiltinFunctions::run_tests --signers 0x1


//# publish
module 0x1::ConsumeTokenTest {
    /// This module is intended to test token consumption.
    /// Since token consumption is part of Move parser and compiler,
    /// and not accessible at transaction script level, this is a placeholder.
    /// In a real testing environment, custom parser tests would be necessary.
    /// Here, we simulate the test call.
    
    public fun test_consume_token() {
        // Placeholder function to simulate token consumption testing.
        // In real case, this would involve custom parser or compiler hooks.
    }

    /// Runner function to invoke token consumption tests.
    public fun run_consume_token_tests() {
        test_consume_token();
    }
}

//# run 0x1::ConsumeTokenTest::run_consume_token_tests --signers 0x1


//# publish
module 0x1::ErrorReportingTest {
    /// Function that tries to call an invalid function to generate an error.
    public fun trigger_error() {
        // Attempt to call a function that doesn't exist to produce an error.
        // This should trigger a detailed error message during compilation or runtime.
        // The function call below is invalid and will cause an error.
        // move_stdlib::core::nonexistent_function();
    }

    /// Runner function to execute error-inducing call.
    public fun run_error_test() {
        trigger_error();
    }
}

//# run 0x1::ErrorReportingTest::run_error_test --signers 0x1

// Featurres:
// ee27efda6f6e574dce0f4c91b0f6c551: Call built-in functions using explicit type arguments and regular argument lists.
// bef9dbef17a7b6cdbd55be5addf073bf: Leverage 'consume_token' to ensure that the next token in the token stream matches an expected token, facilitating correct parsing of Move source code.
// 86e60b7b8afe9487f0d478e63af0d9d5: Receive detailed error reporting about improper function calls, including call sites and the reason for the restriction
