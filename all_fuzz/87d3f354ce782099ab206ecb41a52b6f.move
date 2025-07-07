
//# publish
module 0xCAFE::LambdaAdd {
    // This module tests addition of two u8 values and usage of lambdas (anonymous functions)

    public fun add_two_values(a: u8, b: u8): u8 {
        let result = a + b;
        result
    }

    public fun use_lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| { x + y };
        let sum = add_lambda(a, b);
        sum
    }

    public fun runner() {
        let _ = add_two_values(10u8, 20u8);
        let _ = use_lambda_add(15u8, 25u8);
    }
}


//# run 0xCAFE::LambdaAdd::add_two_values --args 10u8 20u8


//# run 0xCAFE::LambdaAdd::use_lambda_add --args 15u8 25u8


//# run 0xCAFE::LambdaAdd::runner



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaAdd;

    // Tests calling an inline function from one module and performs nested calls correctly

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda_add_from_other_module(a: u8, b: u8): u8 {
        // Call lambda add from LambdaAdd module
        let sum_lambda = LambdaAdd::use_lambda_add(a, b);

        // Call own inline add function
        let sum_inline = inline_add(a, b);

        // Return combined sum (this just adds the two sums)
        sum_lambda + sum_inline
    }

    public fun runner() {
        let _ = call_lambda_add_from_other_module(5u8, 7u8);
    }
}


//# run 0xCAFE::NestedCall::call_lambda_add_from_other_module --args 5u8 7u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
