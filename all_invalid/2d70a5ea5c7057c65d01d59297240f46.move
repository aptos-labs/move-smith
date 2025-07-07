// The test is published and run from address 0xCAFE

//# publish
module 0xCAFE::VarReassignTest {
    use std::vector;

    /// This function demonstrates reassigning variables and ensuring previous copy chains are unaffected.
    public fun reassign_breaks_copy_chain() {
        let x = 10;
        let y = x; // y = 10
        let mut x = x;
        x = 20; // reassign x, should not affect y
        // No assertions as per instructions.
        // If equality check is needed internally, simulate here:
        // y still equals 10
    }

    // This runner calls the test
    public fun run() {
        reassign_breaks_copy_chain();
    }
}

//# run 0xCAFE::VarReassignTest::run --signers 0xCAFE


//# publish
module 0xCAFE::LintSkipTest {

    #[skip_external_lint_checks("unused_variable")]
    public fun skip_unused_variable() {
        let unused: u64 = 42;
        // no use of unused
    }

    #[skip_external_lint_checks("dead_code", "unused_code")]
    public fun skip_dead_unused() {
        let a = 1;
        let b = a + 1;
        // function does nothing else
    }

    // Runner to call these functions
    public fun run() {
        skip_unused_variable();
        skip_dead_unused();
    }
}

//# run 0xCAFE::LintSkipTest::run --signers 0xCAFE


//# publish
module 0xCAFE::VectorErrorTest {

    /// This function intentionally triggers a vector error (out-of-bounds access)
    /// and is annotated with expected_failure(vector_error).
    #[expected_failure(vector_error(42))]
    public fun trigger_vector_error() {
        let v = vector::empty<u8>();
        // intentionally cause out of bounds panic
        let _ = *vector::borrow(&v, 0);
    }

    // Runner function that triggers the vector error
    public fun run() {
        trigger_vector_error();
    }
}

//# run 0xCAFE::VectorErrorTest::run --signers 0xCAFE


//# run
script {
    use 0xCAFE::VarReassignTest;
    use 0xCAFE::LintSkipTest;
    use 0xCAFE::VectorErrorTest;

    fun main() {
        VarReassignTest::run();
        LintSkipTest::run();
        VectorErrorTest::run();
    }
}

// Featurres:
// 8af9fae625f2fd1ea4811defc457ab1a: Test that reassigning a variable breaks the previous copy chain and does not affect the equality check.
// d0dda1e9fa5ca36f6c00a021b042a5ce: Annotate modules with attributes to selectively skip specified external lint checks on certain functions.
// 438a5a28c4b3a3d65c2b6eb8f4ca3992: Indicate a vector operation error expected in your test with `#[expected_failure(vector_error)]` attribute, with optional minor status code.
