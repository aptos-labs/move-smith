
//# publish
module 0xCAFE::MathLambdas {
    // This module will test addition, lambdas, and nested inline function calls.
    use std::signer;

    // Simple function that adds two u8 values and returns the result + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // Function that defines a lambda to multiply two u8 values and then adds a constant
    public fun lambda_multiply_and_add(a: u8, b: u8): u8 {
        let multiply: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let product = multiply(a, b);
        product + 5
    }

    // Inline function that returns a tuple of three values
    public inline fun triple_sum(a: u8, b: u8, c: u8): (u8, u8) {
        (a + b, b + c)
    }

    // Call inline function triple_sum and then call add_and_offset with one of the results
    public fun nested_calls(a: u8, b: u8, c: u8): u8 {
        let (ab_sum, bc_sum) = triple_sum(a, b, c);
        add_and_offset(ab_sum, bc_sum)
    }

    // A "runner" function to call all above functions without arguments where possible
    public fun runner() {
        let _ = add_and_offset(3u8, 4u8);
        let _ = lambda_multiply_and_add(2u8, 5u8);
        let _ = nested_calls(1u8, 2u8, 3u8);
    }
}


//# run 0xCAFE::MathLambdas::add_and_offset --args 4u8 6u8


//# run 0xCAFE::MathLambdas::lambda_multiply_and_add --args 3u8 7u8


//# run 0xCAFE::MathLambdas::nested_calls --args 5u8 6u8 7u8


//# run 0xCAFE::MathLambdas::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
