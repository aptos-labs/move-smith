
//# publish
module 0xCAFE::LambdaAdd {
    // This module tests addition and usage of lambdas

    public fun add_u8_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun nested_lambda(a: u8, b: u8): u8 {
        let mul_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            mul_lambda(x, y) + x + y
        };
        add_lambda(a, b)
    }

    public fun runner(): u8 {
        let sum = add_u8_values(10u8, 15u8);
        let lambda_sum = lambda_add(7u8, 8u8);
        let nested_sum = nested_lambda(2u8, 3u8);
        sum + lambda_sum + nested_sum
    }
}


//# run 0xCAFE::LambdaAdd::add_u8_values --args 20u8 22u8


//# run 0xCAFE::LambdaAdd::lambda_add --args 5u8 6u8


//# run 0xCAFE::LambdaAdd::nested_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaAdd::runner



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaAdd;

    public fun call_inline_add(a: u8, b: u8): u8 {
        LambdaAdd::add_u8_values(a, b)
    }

    public fun call_runner(): u8 {
        LambdaAdd::runner()
    }
}


//# run 0xCAFE::InlineCaller::call_inline_add --args 12u8 34u8


//# run 0xCAFE::InlineCaller::call_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
