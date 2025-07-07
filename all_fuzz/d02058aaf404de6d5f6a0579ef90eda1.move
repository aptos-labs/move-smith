
//# publish
module 0xCAFE::LambdaTest {
    // This module tests lambdas and nested calls

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_sum(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_sum --args 15u8 25u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        LambdaTest::inline_add(a, b)
    }

    public fun call_lambda_sum(x: u8, y: u8): u8 {
        LambdaTest::lambda_sum(x, y)
    }

    public fun combined_call(x: u8, y: u8): u8 {
        let intermediate = call_lambda_sum(x, y);
        call_inline_add(intermediate, 5)
    }

    public fun runner() {
        let _ = call_inline_add(3,4);
        let _ = call_lambda_sum(1,2);
        let _ = combined_call(10, 20);
    }
}


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
