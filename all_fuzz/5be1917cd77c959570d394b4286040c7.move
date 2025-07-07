
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    // A function to add two u8 values and return the result + 1
    public fun add_and_return_plus_one(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 1
    }

    // Function to define and call a lambda that multiplies its input by 2
    public fun double_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 2u8
        };
        lambda(x)
    }

    // Runner function calling add_and_return_plus_one with some constants and double_lambda
    public fun runner(): u8 {
        let val1 = add_and_return_plus_one(10u8, 20u8);
        let val2 = double_lambda(15u8);
        val1 + val2
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_plus_one --args 100u8 50u8


//# run 0xCAFE::LambdaTest::double_lambda --args 22u8


//# run 0xCAFE::LambdaTest::runner




//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    // Calls the inline add_and_return_plus_one function from LambdaTest module
    public fun sum_using_lambda_test(a: u8, b: u8): u8 {
        LambdaTest::add_and_return_plus_one(a, b)
    }

    // Calls double_lambda from LambdaTest
    public fun double_using_lambda_test(x: u8): u8 {
        LambdaTest::double_lambda(x)
    }

    // Call both nested and add results
    public fun nested_runner(): u8 {
        let s = sum_using_lambda_test(3u8, 4u8);
        let d = double_using_lambda_test(5u8);
        s + d
    }
}


//# run 0xCAFE::NestedCall::sum_using_lambda_test --args 7u8 8u8


//# run 0xCAFE::NestedCall::double_using_lambda_test --args 10u8


//# run 0xCAFE::NestedCall::nested_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
