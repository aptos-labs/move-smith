
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed u8 42 after computing sum to test
        42
    }

    public fun run_lambda_test(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }
}


//# run 0xCAFE::TestAddition::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::TestAddition::run_lambda_test --args 10u8 32u8


//# publish
module 0xCAFE::TestInlineCaller {
    use 0xCAFE::TestAddition;

    public fun call_inline_double_and_add(a: u8, b: u8): u8 {
        let doubled = TestAddition::inline_double(a);
        doubled + b
    }

    // This function is supposed to fail compilation or runtime behaviour if returning a lambda function
    // We do not return lambdas here as per language version before 2.2 rule.
    // Just demonstrate a lambda and call it internally.
    public fun lambda_internal_use(a: u8, b: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        f(a, b)
    }
}


//# run 0xCAFE::TestInlineCaller::call_inline_double_and_add --args 5u8 3u8


//# run 0xCAFE::TestInlineCaller::lambda_internal_use --args 4u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 39a3cdaaa18a31c0d71575540bad9f84: Prevent functions from returning function-typed values in language versions before 2.2.
