
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    // A function that adds two u8 numbers and returns u8
    public fun add_two(a: u8, b: u8): u8 {
        let result = a + b;
        if (result > 200) {
            200
        } else {
            result
        }
    }

    // A function that defines and calls a lambda (anonymous function) internally
    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);
        product
    }

    // A function that defines a lambda returning a tuple
    public fun lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + 1, y + 2)
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    // Call add_two from LambdaTest
    public fun call_add_two(): u8 {
        LambdaTest::add_two(100u8, 50u8)
    }

    // Call use_lambda from LambdaTest
    public fun call_use_lambda(): u8 {
        LambdaTest::use_lambda(7u8, 6u8)
    }

    // Call lambda_return_tuple from LambdaTest, then sum the tuple
    public fun call_lambda_return_tuple_and_sum(): u8 {
        let (a, b) = LambdaTest::lambda_return_tuple(3u8, 4u8);
        a + b
    }
}


//# run 0xCAFE::LambdaTest::add_two --args 100u8 50u8


//# run 0xCAFE::LambdaTest::use_lambda --args 8u8 12u8


//# run 0xCAFE::LambdaTest::lambda_return_tuple --args 5u8 10u8


//# run 0xCAFE::CallerModule::call_add_two


//# run 0xCAFE::CallerModule::call_use_lambda


//# run 0xCAFE::CallerModule::call_lambda_return_tuple_and_sum


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
