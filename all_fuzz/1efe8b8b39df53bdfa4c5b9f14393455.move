
//# publish
module 0xCAFE::AddLambdaTest {
    use std::vector;

    // A simple function that adds two u8 and returns the sum + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    // A function containing a lambda that returns sum of two u8 plus 5
    public fun lambda_add(a: u8, b: u8): u8 {
        let f: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y + 5
        };
        f(a, b)
    }

    // An inline function that adds 20 to the given u8
    public inline fun inline_add_20(x: u8): u8 {
        x + 20
    }

    // Runner function that calls add_and_offset and lambda_add
    public fun runner_add_lambda() {
        let res1 = add_and_offset(3u8, 4u8);
        let res2 = lambda_add(5u8, 6u8);
        let _ = res1 + res2;
    }
}


//# publish
module 0xCAFE::CallInlineFromAnother {
    use 0xCAFE::AddLambdaTest;

    public fun call_inline_indirectly(x: u8, y: u8): u8 {
        let sum = x + y;
        // call the inline function from AddLambdaTest module
        AddLambdaTest::inline_add_20(sum)
    }

    public fun runner_call_inline() {
        let val = call_inline_indirectly(2u8, 3u8);
        let _ = val;
    }
}


//# run 0xCAFE::AddLambdaTest::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AddLambdaTest::lambda_add --args 7u8 8u8


//# run 0xCAFE::AddLambdaTest::runner_add_lambda


//# run 0xCAFE::CallInlineFromAnother::call_inline_indirectly --args 5u8 5u8


//# run 0xCAFE::CallInlineFromAnother::runner_call_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
