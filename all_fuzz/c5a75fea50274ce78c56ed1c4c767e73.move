
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 for testing addition and return
        sum + 10
    }

    public fun lambda_double(x: u8): u8 {
        let double_lambda: |u8| u8 has copy+drop = |y: u8| {
            y * 2
        };
        double_lambda(x)
    }

    public fun lambda_sum_and_multiply(a: u8, b: u8, mul: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = sum_lambda(a, b);
        sum * mul
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add_and_lambda(x: u8, y: u8): u8 {
        let added = LambdaTest::inline_add(x, y);
        let doubled = LambdaTest::lambda_double(added);
        doubled
    }

    public fun call_nested_functions(a: u8, b: u8, mul: u8): u8 {
        // Call LambdaTest::lambda_sum_and_multiply
        LambdaTest::lambda_sum_and_multiply(a, b, mul)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::LambdaTest::lambda_double --args 6u8


//# run 0xCAFE::LambdaTest::lambda_sum_and_multiply --args 5u8 4u8 3u8


//# run 0xCAFE::NestedCallTest::call_inline_add_and_lambda --args 3u8 4u8


//# run 0xCAFE::NestedCallTest::call_nested_functions --args 2u8 3u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
