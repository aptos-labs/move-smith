
//# publish
module 0xCAFE::AddWithReturn {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return fixed value 42 regardless of the sum
        42
    }
}


//# run 0xCAFE::AddWithReturn::add_and_return_fixed --args 10u8 32u8


//# publish
module 0xCAFE::LambdaExamples {
    public fun call_lambda_sum(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        lambda(a, b)
    }

    public fun call_lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let c = x + y;
            let d = x * y;
            (c, d)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::LambdaExamples::call_lambda_sum --args 5u8 7u8


//# run 0xCAFE::LambdaExamples::call_lambda_return_tuple --args 3u8 4u8


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::AddWithReturn;

    public inline fun inner_add(x: u8, y: u8): u8 {
        // Call the AddWithReturn::add_and_return_fixed; 
        // Since this always returns 42, ignore returned value here and simulate addition
        let _ = AddWithReturn::add_and_return_fixed(x, y);
        x + y
    }

    public fun call_inner_add(x: u8, y: u8): u8 {
        inner_add(x, y)
    }
}


//# run 0xCAFE::InlineCall::call_inner_add --args 8u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
