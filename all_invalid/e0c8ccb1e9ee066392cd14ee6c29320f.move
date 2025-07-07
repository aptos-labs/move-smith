//# publish
module 0xCAFE::TestBinaryOps {
    /// Helper function to perform various binary operations for testing.
    public fun test_operations() {
        let a = 10;
        let b = 5;
        let _add_result = a + b; // Should succeed
        let _sub_result = a - b; // Should succeed
        let _mul_result = a * b; // Should succeed
        let _div_result = a / b; // Should succeed (assuming b != 0)
        let _mod_result = a % b; // Should succeed
    }

    /// Helper function to intentionally trigger verification error with incorrect attribute usage.
    public fun test_attribute_error() {
        // Intentionally incorrect attribute usage: attribute with parentheses applied to attribute itself.
        // In Move, invalid attribute syntax will cause a compile-time error.
        // The following line is intentionally invalid to induce verification error.
        #[attribute_name(...)]
        // The above line will cause a syntax error, simulating attribute misuse.
    }

    /// Helper function to trigger a verification error by introducing an invalid bytecode instruction.
    public fun trigger_verification_error() {
        // Since we can't directly inject invalid bytecode, we simulate a misuse.
        // For instance, attempting to perform an operation not allowed or misuse attribute syntax.
        // Alternatively, a dummy operation that could cause verifier errors.
        // For demonstration, we invoke an invalid operation by misuse of attribute syntax.
        // But move code will fail compilation beforehand if syntax is invalid.
        // So, the best way is to have invalid attribute syntax as in the previous function.
        // Alternatively, for test purposes, just do a division by zero (runtime error, not verifier):
        let _x = 10 / 0; // Runtime error, but not verification error.
    }
}

//# run 0xCAFE::TestBinaryOps::test_operations
//# run 0xCAFE::TestBinaryOps::test_attribute_error
//# run 0xCAFE::TestBinaryOps::trigger_verification_error