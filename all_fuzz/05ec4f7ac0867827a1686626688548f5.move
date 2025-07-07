
//# publish
module 0xCAFE::NestedModule {
    /// Inline function that adds two u8 values.
    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


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



//# run 0xCAFE::Calculator::add_and_offset --args 5u8 10u8


//# run 0xCAFE::Calculator::multiply_with_lambda --args 6u8 7u8


//# run 0xCAFE::Calculator::nested_call_add --args 11u8 22u8


//# run 0xCAFE::Calculator::test_verification_guard --args 20u8 25u8
