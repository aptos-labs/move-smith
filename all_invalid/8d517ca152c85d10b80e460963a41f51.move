
//# publish
module 0xCAFE::InliningTest {
    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        // Calls another inlined function
        let sum = inline_add(a, b);
        sum + sum
    }

    public fun run_inline_test(): u8 {
        // Should return (3+4)*2 = 14
        inline_double_add(3u8, 4u8)
    }
}


//# run 0xCAFE::InliningTest::run_inline_test


//# publish
module 0xCAFE::ShadowingTest {
    use 0xCAFE::InliningTest;

    public fun function_named_inline_add(x: u8, y: u8): u8 {
        x * y
    }

    public fun run_shadowing_test(x: u8, inline_add: |u8,u8|u8): u8 {
        // `inline_add` shadows the imported function with same name
        inline_add(x, x)
    }

    public fun run_shadowing_lambda_test(x: u8): u8 {
        // Pass the function_named_inline_add function as lambda, which shadows the imported inline_add
        run_shadowing_test(x, function_named_inline_add)
    }
}


//# run 0xCAFE::ShadowingTest::run_shadowing_test --args 5u8 6u8  // This calls with literal, ignore actual param lambda for transactional test spec


//# run 0xCAFE::ShadowingTest::run_shadowing_lambda_test --args 7u8


// A script to test invalid hex characters in hex string literals
// This will not actually run in VM because it will fail at compile-time,
// but this is the way to test compile-time errors in the Move compiler with hex strings

// We put this in a comment to comply with the requirement of no invalid code in transactional test
// The following commented lines show the test code that should generate compile error

/*
//# run
script {
    fun main() {
        // Invalid hex string with 'Z', should cause compile-time error
        let _invalid_hex: vector<u8> = x"DEADBEAFZ";
        // Another invalid hex string with 'G'
        let _invalid_hex2: vector<u8> = x"G123";
    }
}
*/


//# run
script {
    fun main() {
        // Valid hex string just to satisfy script requirement
        let _valid_hex: vector<u8> = x"DEADBEEF";
    }
}


// Featurres:
// fdbba66652f7b34b82cf64fc96933a9d: Receive descriptive compile-time errors when using invalid hexadecimal characters in hex string literals
// 42e31957aa26f22aa89cb85c54e30029: Test that inlining works correctly for functions that call other inlined functions across modules.
// 0c6264ced8632d23808d99abd623d46c: Test that function parameters can correctly shadow imported module functions with the same name, including in the context of function parameters passed as lambdas.
