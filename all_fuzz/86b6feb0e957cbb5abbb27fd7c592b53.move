
//# publish
module 0xCAFE::MathModule {
    // Module to test basic arithmetic and inline function calls

    public inline fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return_fixed(a: u8, b: u8): u8 {
        let sum = add_two_values(a, b);
        sum + 10u8
    }

    public fun call_inline_in_nested_function(a: u8, b: u8): u8 {
        // Calls add_two_values inline function then adds 5
        let inter = add_two_values(a, b);
        inter + 5u8
    }
}


//# publish
module 0xCAFE::LambdaExample {
    // Module to test lambda expressions

    public fun lambda_add_mul(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }

    public fun lambda_call_with_arg(x: u8, f: |u8|u8): u8 {
        f(x)
    }

    public fun example_lambda_usage(): u8 {
        let lambda_inc: |u8|u8 has copy+drop = |x: u8| { x + 1 };
        lambda_call_with_arg(41u8, lambda_inc)
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    // Module to test nested cross-module inline function call

    use 0xCAFE::MathModule;

    public fun nested_call(a: u8, b: u8): u8 {
        let v = MathModule::call_inline_in_nested_function(a, b);
        v + 1u8
    }
}


//# run 0xCAFE::MathModule::compute_and_return_fixed --args 5u8 10u8


//# run 0xCAFE::MathModule::call_inline_in_nested_function --args 3u8 7u8


//# run 0xCAFE::LambdaExample::lambda_add_mul --args 4u8 6u8


//# run 0xCAFE::LambdaExample::example_lambda_usage


//# run 0xCAFE::NestedCallModule::nested_call --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
