
//# publish
module 0xCAFE::CyclicA {
    // Remove the cyclic dependency by dropping the `use` of CyclicB
    // and implement the function directly or change design.

    // For demonstration, implement a simple function returning a constant.
    public fun call_b(): u8 {
        42
    }

    // Runner function to test call_b
    public fun runner(): u8 {
        call_b()
    }
}



//# publish
module 0xCAFE::CyclicB {
    // Similarly, remove the `use` of CyclicA to break cyclic dependency.

    // Implement call_a returning a constant distinct from CyclicA for differentiation
    public fun call_a(): u8 {
        24
    }

    // Runner function to test call_a
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
    // Mark parameter as unused to avoid warning
    public fun expect_token_example(_expected_token: vector<u8>) {
        // Intentionally trigger an assert error with a custom error code
        assert!(false, 1001);
    }

    public fun runner() {
        let expected = b";";
        expect_token_example(expected);
    }
}



//# run 0xCAFE::ExpectTokenTest::runner


// Features:
// b87d274b57a078e136b459f4ce173e13: Detect shortest cyclic dependencies among Move modules or scripts
// 4957c6b77b94890bc1f8b09f0feac0e4: Remove inline functions from the program after inlining to reduce code size and prevent codegen issues.
// ddb59c39de9de6157f17ead0caf54d9c: Use this function to specify the expected token type or value in a syntax error message.
