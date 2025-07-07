
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_numbers(x: u8, y: u8): u8 {
        let sum = x + y;
        let result = if (sum > 10) {
            42u8
        } else {
            0u8
        };
        result
    }

    public fun run_lambda_demo(x: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };

        let multiply_lambda: |u8, u8|u8 has copy + drop = |a: u8, b: u8| {
            a * b
        };

        let sum = add_lambda(x, 2u8);
        let product = multiply_lambda(x, 3u8);

        let max = if (sum > product) { sum } else { product };
        max
    }
}


//# publish
module 0xCAFE::NestedFunctionCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let intermediate = inline_add(x, y);
        let result = LambdaTest::add_two_numbers(intermediate, 5u8);
        result
    }
}


//# run 0xCAFE::LambdaTest::add_two_numbers --args 4u8 7u8


//# run 0xCAFE::LambdaTest::add_two_numbers --args 3u8 4u8


//# run 0xCAFE::LambdaTest::run_lambda_demo --args 5u8


//# run 0xCAFE::NestedFunctionCall::call_nested_functions --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
