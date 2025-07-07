
//# publish
module 0xCAFE::LambdaTest {
    use std::vector;

    // Simple function to add two u8 and then add 5
    public fun add_then_five(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    // Function including a lambda that computes sum and product of two u8 numbers
    public fun lambda_sum_product(a: u8, b: u8): (u8, u8) {
        let calc: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            (x + y, x * y)
        };
        calc(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        // Call inline function from LambdaTest module
        LambdaTest::inline_add(a, b)
    }

    public fun nested_lambda_call(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            LambdaTest::inline_add(x, y) + 1
        };
        lambda(a, b)
    }

    public fun runner(): u8 {
        // Combine calls for nested testing
        let part1 = call_inline_add(10u8, 20u8);
        let part2 = nested_lambda_call(5u8, 5u8);
        part1 + part2
    }
}


//# run 0xCAFE::LambdaTest::add_then_five --args 3u8 4u8


//# run 0xCAFE::LambdaTest::lambda_sum_product --args 7u8 8u8


//# run 0xCAFE::NestedCalls::call_inline_add --args 15u8 25u8


//# run 0xCAFE::NestedCalls::nested_lambda_call --args 2u8 3u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
