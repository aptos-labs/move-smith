
//# publish
module 0xCAFE::MathModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to distinguish behavior
        sum + 10
    }

    public fun lambda_example(a: u8): u8 {
        let add_five: |u8|u8 has copy+drop = |x: u8| {
            x + 5
        };
        add_five(a)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::UseMathModule {
    use 0xCAFE::MathModule;

    public fun call_add_and_inline(a: u8, b: u8): u8 {
        let sum1 = MathModule::add_two_values(a, b);
        let sum2 = MathModule::inline_add(a, b);
        sum1 + sum2
    }

    public fun use_lambda_from_math(a: u8): u8 {
        MathModule::lambda_example(a)
    }

    public fun runner() {
        let _ = call_add_and_inline(3u8, 4u8);
        let _ = use_lambda_from_math(7u8);
    }
}


//# run 0xCAFE::MathModule::add_two_values --args 5u8 6u8


//# run 0xCAFE::MathModule::lambda_example --args 3u8


//# run 0xCAFE::UseMathModule::call_add_and_inline --args 2u8 8u8


//# run 0xCAFE::UseMathModule::use_lambda_from_math --args 10u8


//# run 0xCAFE::UseMathModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
