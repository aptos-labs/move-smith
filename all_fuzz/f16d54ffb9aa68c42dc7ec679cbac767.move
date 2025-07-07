
//# publish
module 0xCAFE::NestedInline {
    // This module provides an inline function that adds two u8 numbers and another function that doubles its input.
    public inline fun add_two_numbers(a: u8, b: u8): u8 {
        a + b
    }

    public fun double(x: u8): u8 {
        let sum = add_two_numbers(x, x);
        sum
    }
}


//# publish
module 0xCAFE::LambdaTesting {
    use 0xCAFE::NestedInline;

    public fun compute_sum_plus_one(x: u8, y: u8): u8 {
        // A lambda to add two numbers
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        let sum = add_lambda(x, y);

        // Call a function that doubles sum using inline function of another module
        let doubled = NestedInline::double(sum);

        // Return doubled + 1 to test addition and lambda usage
        doubled + 1
    }

    public fun run_lambda() {
        let lambda: |u8| u8 has copy+drop = |a: u8| a * 2;
        let _ = lambda(5u8);
    }
}


//# run 0xCAFE::LambdaTesting::compute_sum_plus_one --args 3u8 4u8


//# run 0xCAFE::LambdaTesting::run_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
