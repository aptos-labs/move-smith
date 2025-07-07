
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    // Function to add two u8 numbers and return their sum plus a fixed offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function defining and using a lambda that multiplies two u8 numbers and returns the product plus 1
    public fun lambda_multiply_plus_one(x: u8, y: u8): u8 {
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1u8
        };
        multiplier(x, y)
    }

    // Inline function returning a tuple with increment and decrement of input
    public inline fun inc_dec(x: u8): (u8, u8) {
        (x + 1u8, x - 1u8)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    // Calls the inline function inc_dec from LambdaTest and returns the sum of the two tuple results
    public fun call_inc_dec(x: u8): u8 {
        let (inc, dec) = LambdaTest::inc_dec(x);
        inc + dec
    }

    // Calls add_and_offset from LambdaTest and lambda_multiply_plus_one in a nested manner
    public fun nested_lambda_add(x: u8, y: u8): u8 {
        let partial_sum = LambdaTest::add_and_offset(x, y);
        let lambda_result = LambdaTest::lambda_multiply_plus_one(x, y);
        partial_sum + lambda_result
    }
}


//# run 0xCAFE::LambdaTest::add_and_offset --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_multiply_plus_one --args 3u8 4u8


//# run 0xCAFE::InlineCaller::call_inc_dec --args 5u8


//# run 0xCAFE::InlineCaller::nested_lambda_add --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
