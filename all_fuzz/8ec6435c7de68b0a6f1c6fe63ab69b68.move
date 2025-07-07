
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            100u8
        }
    }

    public fun lambda_expression_example(x: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        // Use lambda with one argument `x` and constant 1u8
        adder(x, 1u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::LambdaTest::add_and_return --args 5u8 6u8


//# run 0xCAFE::LambdaTest::add_and_return --args 2u8 3u8


//# run 0xCAFE::LambdaTest::lambda_expression_example --args 10u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Calls the inline function defined in LambdaTest module
        LambdaTest::inline_add(a, b)
    }

    public fun runner(): u8 {
        let result = call_inline_add(7u8, 8u8);
        result
    }
}


//# run 0xCAFE::NestedCall::call_inline_add --args 3u8 4u8


//# run 0xCAFE::NestedCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
