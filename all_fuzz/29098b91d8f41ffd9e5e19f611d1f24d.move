
//# publish
module 0xCAFE::LambdaAdd {
    // Test 1: function that adds two u8 values and then returns a fixed value (e.g., 42)
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // ignore sum, just return 42
        42u8
    }

    // Test 2: function containing lambda expressions
    public fun lambda_test(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda(x, y);
        sum
    }
}


//# run 0xCAFE::LambdaAdd::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::LambdaAdd::lambda_test --args 15u8 27u8


//# publish
module 0xCAFE::InlineCalls {
    use 0xCAFE::LambdaAdd;

    // Function that calls lambda_test from LambdaAdd
    public fun call_lambda_add(x: u8, y: u8): u8 {
        // call lambda_test from LambdaAdd module that adds two values
        LambdaAdd::lambda_test(x, y)
    }

    // Function that calls add_and_return_fixed inline, then calls lambda_test and returns their sum
    public fun call_both_add_and_lambda(x: u8, y: u8): u8 {
        let fixed = LambdaAdd::add_and_return_fixed(x, y);
        let lambda_sum = LambdaAdd::lambda_test(x, y);
        fixed + lambda_sum
    }
}


//# run 0xCAFE::InlineCalls::call_lambda_add --args 40u8 2u8


//# run 0xCAFE::InlineCalls::call_both_add_and_lambda --args 1u8 1u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
