// -------------
// 1. Generate bytecode for a function based on its AST representation in the environment.
// -------------

//# publish
module 0xCAFE::AstBytecodeTest {
    // Simple add function to generate bytecode via Move compiler
    public fun add(a: u64, b: u64): u64 {
        a + b
    }
    // A runner for test
    public fun run() {
        let result = Self::add(1, 2);
        // Use result so it's not optimized away
        assert!(result == 3, 1);
    }
}
//# run 0xCAFE::AstBytecodeTest::run --signers 0xCAFE

// -------------
// 2. Declare functions as native to indicate outside-implemented code.
// -------------

//# publish
module 0xCAFE::NativeFuncTest {
    // Declare a native function
    native public fun native_sqrt(x: u64): u64;

    // Function to test native
    public fun call_native(): u64 {
        // Call the natively linked sqrt
        Self::native_sqrt(16)
    }

    public fun runner() {
        let sqrt = Self::call_native();
        // Use value (assume native_sqrt(16) would return 4)
        let _ = sqrt;
    }
}
//# run 0xCAFE::NativeFuncTest::runner --signers 0xCAFE

// -------------
// 3. Use #[expected_failure] attribute. Ensure it is only on #[test].
// -------------

//# publish
module 0xCAFE::ExpectedFailureTest {
    use std::testing;

    /// This test will fail, and it's expected to do so.
    #[test]
    #[expected_failure]
    public fun will_fail() {
        // This assertion will fail
        assert!(false, 77);
    }

    // This (incorrect!) use of #[expected_failure] on a non-test function
    // should be rejected by the compiler.
    // Uncommenting the next lines would make the compiler error.

    // #[expected_failure]
    // public fun not_a_test() { }
}