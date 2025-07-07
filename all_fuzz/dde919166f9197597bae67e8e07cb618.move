
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;

        // Macro style call: using assert! macro to check sum is less than max u8
        assert!(sum < 250, 999);

        // Return fixed value instead of sum to test correct flow
        42u8
    }

    public fun lambda_test(): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(10u8, 32u8)
    }

    public inline fun inline_two_returns(a: u8): (u8, u8) {
        (a + 1, a + 2)
    }
}


//# publish
module 0xCAFE::UseAddModule {
    use 0xCAFE::AddModule;

    public fun call_inline_with_lambda(x: u8): u8 {
        let (r1, r2) = AddModule::inline_two_returns(x);
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(r1, r2)
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_test


//# run 0xCAFE::UseAddModule::call_inline_with_lambda --args 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 39a5276d71bb4576631a14e3c7dab09f: Support functions with multiple return values by generating appropriate result temporaries and labels.
// a41ec282b293eaafccf1998093f292df: Create macro calls by following a name with an exclamation mark '!' and call arguments in parentheses or as a call expression.
// fb32f3b3b1dcf46b73265725e707d593: Specify the address for a Move module, which can be checked for redundancy and correctness.
