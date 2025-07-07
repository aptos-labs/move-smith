
//# publish
module 0xCAFE::LambdaAndInline {
    use std::vector;

    // Inline function that adds two u8 values and returns u8
    public inline fun add_two_u8(a: u8, b: u8): u8 {
        a + b
    }

    // Function that returns a u8 equal to sum + 10, using the inline add_two_u8 function
    public fun sum_and_add_ten(x: u8, y: u8): u8 {
        let sum = add_two_u8(x, y);
        sum + 10
    }

    // Function containing a lambda expression that takes two u8 and returns their product plus 5
    public fun lambda_product_plus_five(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let product = x * y;
            product + 5
        };
        lambda(a, b)
    }

    // Runner function with no args that calls the above functions
    public fun runner() {
        let _ = sum_and_add_ten(3u8, 4u8);
        let _ = lambda_product_plus_five(5u8, 6u8);
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaAndInline;

    public fun call_sum_and_add_ten(a: u8, b: u8): u8 {
        LambdaAndInline::sum_and_add_ten(a, b)
    }

    public fun call_lambda_product_plus_five(a: u8, b: u8): u8 {
        LambdaAndInline::lambda_product_plus_five(a, b)
    }

    public fun call_inline_nested(a: u8, b: u8): u8 {
        // Call inline add_two_u8 function nested inside sum_and_add_ten to verify nested inline function call
        call_sum_and_add_ten(a, b)
    }
}


//# run 0xCAFE::LambdaAndInline::sum_and_add_ten --args 10u8 20u8


//# run 0xCAFE::LambdaAndInline::lambda_product_plus_five --args 2u8 3u8


//# run 0xCAFE::LambdaAndInline::runner


//# run 0xCAFE::CallerModule::call_sum_and_add_ten --args 5u8 7u8


//# run 0xCAFE::CallerModule::call_lambda_product_plus_five --args 4u8 9u8


//# run 0xCAFE::CallerModule::call_inline_nested --args 8u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
