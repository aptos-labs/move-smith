
//# publish
module 0xCAFE::AddAndLambda {
    use std::vector;

    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // return sum + 10 just to have a specific return value involving the sum
        sum + 10
    }

    public fun apply_lambda_and_return(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestCall {
    use 0xCAFE::AddAndLambda;

    public fun nested_sum_call(a: u8, b: u8): u8 {
        // call inline_add in the other module to add a and b
        let inner_sum = AddAndLambda::inline_add(a, b);
        // then call add_then_return_sum to add inner_sum and 5 (so adding nested calls)
        AddAndLambda::add_then_return_sum(inner_sum, 5u8)
    }

    public fun call_lambda_indirectly(a: u8, b: u8): u8 {
        // calls the lambda function from AddAndLambda through apply_lambda_and_return
        AddAndLambda::apply_lambda_and_return(a, b)
    }
}


//# run 0xCAFE::AddAndLambda::add_then_return_sum --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::apply_lambda_and_return --args 12u8 15u8


//# run 0xCAFE::NestCall::nested_sum_call --args 2u8 3u8


//# run 0xCAFE::NestCall::call_lambda_indirectly --args 9u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
