
//# publish
module 0xCAFE::LambdaTest {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun apply_lambda(x: u8, lambda: |u8|u8): u8 {
        lambda(x)
    }

    public fun example_lambda_usage(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        let sum = add_lambda(x, y);

        let inc_lambda: |u8| u8 has copy + drop = |z: u8| {
            add_u8(z, 1u8)
        };

        let result = apply_lambda(sum, inc_lambda);
        result
    }
}


//# run 0xCAFE::LambdaTest::example_lambda_usage --args 4u8 5u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun nested_call(a: u8, b: u8): u8 {
        // directly call LambdaTest::add_u8 (inline function) and then use result in LambdaTest::apply_lambda
        let sum = LambdaTest::add_u8(a, b);
        let add_two = |x: u8| { LambdaTest::add_u8(x, 2u8) };
        LambdaTest::apply_lambda(sum, add_two)
    }
}


//# run 0xCAFE::NestedCall::nested_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
