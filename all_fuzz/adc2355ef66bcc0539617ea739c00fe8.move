
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_and_return_specific_value(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return 42 if the sum is 42, else return the sum + 1
        if (sum == 42) {
            42
        } else {
            sum + 1
        }
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun lambda_capture_and_call(x: u8): u8 {
        let captured = x;
        let lambda: |u8| u8 has copy+drop = |y: u8| {
            // capture variable from outer scope + parameter y
            captured + y
        };
        lambda(10u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_specific_value --args 20u8 22u8


//# run 0xCAFE::LambdaTest::add_and_return_specific_value --args 5u8 10u8


//# run 0xCAFE::LambdaTest::lambda_add --args 7u8 8u8


//# run 0xCAFE::LambdaTest::lambda_capture_and_call --args 5u8



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun add_one(a: u8): u8 {
        a + 1
    }

    public fun call_external_inline_add(a: u8, b: u8): u8 {
        // Call a lambda function from LambdaTest
        let lambda_sum = LambdaTest::lambda_add(a, b);

        // Call the inline add_one function with the lambda sum
        add_one(lambda_sum)
    }
}


//# run 0xCAFE::NestedInlineCall::call_external_inline_add --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
