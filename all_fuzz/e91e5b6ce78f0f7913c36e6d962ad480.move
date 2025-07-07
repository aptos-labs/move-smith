
//# publish
module 0xCAFE::MathModule {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun lambdas_demo(): u8 {
        let add = |x: u8, y: u8| {
            x + y
        };
        let mul = |x: u8, y: u8| {
            x * y
        };
        let sum = add(3u8, 4u8);
        let product = mul(3u8, 4u8);
        sum + (product / 2u8)
    }

    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MathModule;

    public fun call_inline_sum(a: u8, b: u8): u8 {
        MathModule::inline_sum(a, b)
    }

    public fun call_add_then_return_fixed(a: u8, b: u8): u8 {
        MathModule::add_then_return_fixed(a, b)
    }

    public fun call_lambda_demo(): u8 {
        MathModule::lambdas_demo()
    }
}


//# run 0xCAFE::MathModule::add_then_return_fixed --args 10u8 32u8


//# run 0xCAFE::MathModule::lambdas_demo


//# run 0xCAFE::NestedCall::call_inline_sum --args 7u8 8u8


//# run 0xCAFE::NestedCall::call_add_then_return_fixed --args 20u8 22u8


//# run 0xCAFE::NestedCall::call_lambda_demo


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
