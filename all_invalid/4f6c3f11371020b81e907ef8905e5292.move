
//# publish
module 0xCAFE::CyclicA {
    use 0xCAFE::CyclicB;

    public fun call_b(): u8 {
        CyclicB::call_a()
    }

    // Runner function to test cyclic call
    public fun runner(): u8 {
        call_b()
    }
}


//# publish
module 0xCAFE::CyclicB {
    use 0xCAFE::CyclicA;

    public fun call_a(): u8 {
        CyclicA::call_b()
    }

    // Runner function to test cyclic call
    public fun runner(): u8 {
        call_a()
    }
}


//# run 0xCAFE::CyclicA::runner


//# run 0xCAFE::CyclicB::runner



//# publish
module 0xCAFE::InlineRemovalTest {
    // Inline function, should be removed after inlining
    public inline fun add_inline(a: u64, b: u64): u64 {
        a + b
    }

    // Non-inline function calling inline function
    public fun add_wrapper(x: u64, y: u64): u64 {
        add_inline(x, y)
    }

    // Runner function calling add_wrapper without arguments
    public fun runner(): u64 {
        add_wrapper(40, 2)
    }
}


//# run 0xCAFE::InlineRemovalTest::runner



//# publish
module 0xCAFE::ExpectTokenTest {
    // Function that triggers a syntax error message
    public fun expect_token_example(expected_token: vector<u8>) {
        // Intentionally trigger an error with expected token message
        // In Move, we can't literally throw syntax errors in functions,
        // but we use assert! with error code as simulation.
        // This function expects to be compiled with the error message mentioning expected_token.
        // This is a placeholder to exercise Move compiler error messages.
        assert!(false, 1001);
    }

    public fun runner() {
        let expected = b";";
        expect_token_example(expected);
    }
}


//# run 0xCAFE::ExpectTokenTest::runner


// Featurres:
// b87d274b57a078e136b459f4ce173e13: Detect shortest cyclic dependencies among Move modules or scripts
// 4957c6b77b94890bc1f8b09f0feac0e4: Remove inline functions from the program after inlining to reduce code size and prevent codegen issues.
// ddb59c39de9de6157f17ead0caf54d9c: Use this function to specify the expected token type or value in a syntax error message.
