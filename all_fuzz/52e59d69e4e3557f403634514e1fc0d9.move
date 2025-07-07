
//# publish
module 0xCAFE::LambdaTest {
    public fun compute_addition(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            100u8
        } else {
            sum
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let inline_result = LambdaTest::inline_addition(a, b);
        let lambda_result = LambdaTest::with_lambda(a, b);
        inline_result + lambda_result
    }

    public fun runner() {
        let _ = call_inline_and_lambda(10u8, 20u8);
    }
}


//# run 0xCAFE::LambdaTest::compute_addition --args 60u8 50u8


//# run 0xCAFE::LambdaTest::with_lambda --args 15u8 25u8


//# run 0xCAFE::NestedCalls::call_inline_and_lambda --args 10u8 20u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
