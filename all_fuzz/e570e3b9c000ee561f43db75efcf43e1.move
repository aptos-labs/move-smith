
//# publish
module 0xCAFE::AdditionLambda {
    // A simple inline function that returns the sum of two u8 values
    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }

    // Function containing a lambda expression that sums two u8 values and returns a fixed u8 value
    public fun test_lambda_sum(): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let _ = sum_lambda(7u8, 8u8);
        // Returns a fixed value after lambda invocation
        42u8
    }

    // Function that uses the lambda and returns the lambda result as well as calls inline function
    public fun lambda_and_inline(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum_result = lambda(a, b);
        let inline_result = add_inline(a, b);
        // Return sum_result + inline_result
        sum_result + inline_result
    }
}


//# run 0xCAFE::AdditionLambda::test_lambda_sum


//# run 0xCAFE::AdditionLambda::lambda_and_inline --args 10u8 20u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AdditionLambda;

    // Call the inline function add_inline from AdditionLambda module
    public fun call_add_inline(a: u8, b: u8): u8 {
        AdditionLambda::add_inline(a, b)
    }

    // Call the lambda_and_inline function from AdditionLambda module
    public fun call_lambda_and_inline(a: u8, b: u8): u8 {
        AdditionLambda::lambda_and_inline(a, b)
    }
}


//# run 0xCAFE::NestedCalls::call_add_inline --args 15u8 25u8


//# run 0xCAFE::NestedCalls::call_lambda_and_inline --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
