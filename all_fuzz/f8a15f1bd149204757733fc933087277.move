
//# publish
module 0xCAFE::AddAndLambda {
    // Test adding two u8 values and returning a specific value
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    // Function containing a lambda expression that doubles a u8 value
    public fun lambda_double(x: u8): u8 {
        let double_fn: |u8|u8 = |a: u8| { a * 2u8 };
        double_fn(x)
    }

    // Runner function to test lambda_double internally
    public fun run_lambda_double() {
        let _ = lambda_double(5u8); // We just run it for coverage
    }
}


//# run 0xCAFE::AddAndLambda::add_and_return --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::lambda_double --args 6u8


//# run 0xCAFE::AddAndLambda::run_lambda_double


//# publish
module 0xCAFE::NestedInline {
    use 0xCAFE::AddAndLambda;

    // Inline function that returns a tuple (u8, u8)
    public inline fun inliner(x: u8): (u8, u8) {
        (x + 1u8, x + 2u8)
    }

    // Function that calls inline function in this module and AddAndLambda::add_and_return
    public fun nested_calls(x: u8, y: u8): u8 {
        let (a, b) = inliner(x);
        let temp = AddAndLambda::add_and_return(a, b);
        temp + y
    }

    // Runner no-arg function to call nested_calls internally for coverage
    public fun run_nested_calls() {
        let _ = nested_calls(3u8, 4u8);
    }
}


//# run 0xCAFE::NestedInline::nested_calls --args 5u8 9u8


//# run 0xCAFE::NestedInline::run_nested_calls


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
