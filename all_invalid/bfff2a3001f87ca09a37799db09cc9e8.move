
//# publish
module 0xCAFE::Calculator {
    /// Adds two u8 values and then adds a fixed constant, returns the sum.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // Add fixed offset 10
        let result = sum + 10u8;
        result
    }

    /// Defines and uses a lambda (anonymous function) to multiply two u8 values.
    public fun multiply_with_lambda(x: u8, y: u8): u8 {
        let mul: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        mul(x, y)
    }

    /// Calls inline function from NestedModule to demonstrate nested calls.
    public fun nested_call_add(x: u8, y: u8): u8 {
        0xCAFE::NestedModule::inline_add(x, y)
    }

    /// Test verification function that runs some assertions only if compiling with verification enabled.
    // verifier(ignore)]
    public fun test_verification_guard(a: u8, b: u8): u8 {
        let sum = a + b;
        // Verification-only: require sum is less than 50 (would be verified statically).
        // This code is ignored by the VM.
        spec {
            assume(sum < 50);
        };
        sum
    }
}


//# publish
module 0xCAFE::NestedModule {
    /// Inline function that adds two u8 values.
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::Calculator::add_and_offset --args 5u8 10u8


//# run 0xCAFE::Calculator::multiply_with_lambda --args 6u8 7u8


//# run 0xCAFE::Calculator::nested_call_add --args 11u8 22u8


//# run 0xCAFE::Calculator::test_verification_guard --args 20u8 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 895e8135296d048d3ab43409b23b1fb0: Include or exclude test and verification code sections during Move compilation.
