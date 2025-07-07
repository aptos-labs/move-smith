
//# publish
module 0xCAFE::MathOps {
    public fun add_and_offset(a: u8, b: u8, offset: u8): u8 {
        let sum = a + b;
        sum + offset
    }

    public fun test_lambda(): u8 {
        let adder_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder_lambda(5u8, 7u8);
        result
    }
}


//# publish
module 0xCAFE::LambdaTester {
    public fun call_lambda_return_sum(): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        sum_lambda(10u8, 20u8)
    }

    public fun nested_lambda_call(): u8 {
        let f: |u8| u8 has copy+drop = |x: u8| {
            let inner_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
                a + b + x
            };
            inner_lambda(1u8, 2u8)
        };
        f(5u8)
    }
}


//# publish
module 0xCAFE::CrossModule {
    use 0xCAFE::MathOps;

    public fun call_inline_add_and_offset(): u8 {
        // call inline addition function from MathOps module
        MathOps::add_and_offset(3u8, 4u8, 2u8)
    }

    public fun nested_call(): u8 {
        // call a function containing lambda from MathOps module
        let lambda_sum = MathOps::test_lambda();
        // add an offset to lambda_sum
        lambda_sum + 1u8
    }
}


//# run 0xCAFE::MathOps::add_and_offset --args 5u8 6u8 1u8


//# run 0xCAFE::MathOps::test_lambda


//# run 0xCAFE::LambdaTester::call_lambda_return_sum


//# run 0xCAFE::LambdaTester::nested_lambda_call


//# run 0xCAFE::CrossModule::call_inline_add_and_offset


//# run 0xCAFE::CrossModule::nested_call


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
