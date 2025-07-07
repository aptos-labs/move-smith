
//# publish
module 0xCAFE::Adder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return some fixed value plus the sum to test computation
        42u8 + sum
    }

    public fun lambda_add_sub(a: u8, b: u8): (u8, u8) {
        let adder: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let addition = x + y;
            let subtraction = if (x > y) {x - y} else {y - x};
            (addition, subtraction)
        };
        adder(a, b)
    }
}


//# run 0xCAFE::Adder::add_two_values --args 5u8 10u8


//# run 0xCAFE::Adder::lambda_add_sub --args 20u8 15u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        // Call add_two_values from Adder
        let sum_plus_const = Adder::add_two_values(a, b);
        // Capture the lambda_add_sub results
        let (add_result, _) = Adder::lambda_add_sub(a, b);
        // Add from inline call plus the first element from lambda
        sum_plus_const + add_result
    }

    // Runner with no arguments to test nested function calls
    public fun runner(): u8 {
        call_inline_and_lambda(3u8, 4u8)
    }
}


//# run 0xCAFE::NestedCalls::call_inline_and_lambda --args 7u8 8u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
