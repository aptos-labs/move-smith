
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_nested_lambda(a: u8, b: u8): u8 {
        // Nested lambdas calling each other
        let inner_lambda: |u8|u8 has copy+drop = |x: u8| {
            x + 1u8
        };
        let outer_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let s = inner_lambda(x);
            s + y
        };
        outer_lambda(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_u8 --args 3u8 5u8


//# run 0xCAFE::LambdaTest::call_lambda --args 10u8 15u8


//# run 0xCAFE::LambdaTest::call_nested_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::LambdaTest;

    // Inline function returning a tuple
    public inline fun inline_add_and_double(a: u8): (u8, u8) {
        (a + 1, a * 2)
    }

    public fun call_lambda_test_add(a: u8, b: u8): u8 {
        LambdaTest::add_u8(a, b)
    }

    public fun call_inline_and_lambda(a: u8): u8 {
        let (inc, dbl) = inline_add_and_double(a);
        LambdaTest::call_lambda(inc, dbl)
    }
}


//# run 0xCAFE::NestedInlineCall::call_lambda_test_add --args 20u8 22u8


//# run 0xCAFE::NestedInlineCall::call_inline_and_lambda --args 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
