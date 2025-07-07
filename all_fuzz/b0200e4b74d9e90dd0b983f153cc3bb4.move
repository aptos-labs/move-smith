
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_values_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::LambdaTest::add_two_values_and_return_sum --args 5u8 7u8


//# run 0xCAFE::LambdaTest::lambda_test --args 10u8 20u8


//# publish
module 0xCAFE::NestedCallsTest {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add_and_add_one(x: u8, y: u8): u8 {
        let base_sum = LambdaTest::inline_add(x, y);
        base_sum + 1
    }

    public fun nested_lambda_usage(x: u8, y: u8): u8 {
        let base_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            LambdaTest::inline_add(a, b)
        };
        base_lambda(x, y)
    }
}


//# run 0xCAFE::NestedCallsTest::call_inline_add_and_add_one --args 2u8 3u8


//# run 0xCAFE::NestedCallsTest::nested_lambda_usage --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
