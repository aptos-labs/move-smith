
//# publish
module 0xCAFE::Addition {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::Addition::add_then_return_sum --args 10u8 20u8


//# run 0xCAFE::Addition::use_lambda --args 15u8 25u8


//# publish
module 0xCAFE::LambdaExamples {
    public fun lambda_ignore_params_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |_: u8, y: u8| {
            y + 1
        };
        lambda(100u8, 200u8)
    }
}


//# run 0xCAFE::LambdaExamples::lambda_ignore_params_example


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::Addition;

    public inline fun nested_inline_call(a: u8, b: u8): u8 {
        Addition::add_then_return_sum(a, b)
    }

    public fun call_with_closure(a: u8, b: u8): u8 {
        let closure: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let result = nested_inline_call(a, b);
        result + closure(a, b)
    }
}


//# run 0xCAFE::InlineCaller::nested_inline_call --args 7u8 8u8


//# run 0xCAFE::InlineCaller::call_with_closure --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 828d977b5d7b96456af4d7fd8c60f323: Test that inline functions can accept closures as arguments and properly handle closures with ignored parameters using underscores.
