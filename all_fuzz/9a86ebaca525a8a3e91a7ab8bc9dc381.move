
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    // A simple function that adds two u8 values and returns x+y+10u8
    public fun add_and_add_ten(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // A function with lambda that takes two u8, multiplies, then adds 5, returns result
    public fun lambda_multiple_operations(x: u8, y: u8): u8 {
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let product = multiplier(x, y);
        product + 5
    }

    // A runner function that calls add_and_add_ten and lambda_multiple_operations for testing
    public fun runner() {
        let _ = add_and_add_ten(3u8, 4u8);
        let _ = lambda_multiple_operations(3u8, 5u8);
    }
}


//# run 0xCAFE::LambdaTest::add_and_add_ten --args 7u8 8u8


//# run 0xCAFE::LambdaTest::lambda_multiple_operations --args 4u8 6u8


//# run 0xCAFE::LambdaTest::runner



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;
    use std::signer;

    // A function that calls the inline add_and_add_ten function from LambdaTest module
    public fun call_add_and_add_ten(x: u8, y: u8): u8 {
        LambdaTest::add_and_add_ten(x, y)
    }

    // Calls the lambda_multiple_operations from LambdaTest 
    public fun call_lambda_multiple_operations(x: u8, y: u8): u8 {
        LambdaTest::lambda_multiple_operations(x, y)
    }

    // Runner function calling both and returning sum of their results
    public fun runner(): u8 {
        let a = call_add_and_add_ten(2u8, 3u8);
        let b = call_lambda_multiple_operations(3u8, 3u8);
        a + b
    }
}


//# run 0xCAFE::InlineCaller::call_add_and_add_ten --args 10u8 20u8


//# run 0xCAFE::InlineCaller::call_lambda_multiple_operations --args 2u8 7u8


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
