
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun lambda_adder(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(10u8, 32u8)
    }

    public fun nested_lambda(): u8 {
        let multiply_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            sum
        };
        let sum = add_lambda(3u8, 7u8);
        multiply_lambda(sum, 2u8)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 12u8 20u8


//# run 0xCAFE::LambdaTest::lambda_adder


//# run 0xCAFE::LambdaTest::nested_lambda


//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    public inline fun inline_func(val1: u8, val2: u8): u8 {
        val1 + val2
    }

    public fun call_inline_and_lambda(val1: u8, val2: u8): u8 {
        let inline_sum = inline_func(val1, val2);

        let lambda_sum = LambdaTest::add_and_return_sum(inline_sum, 5u8);
        lambda_sum
    }
}


//# run 0xCAFE::InlineCallTest::call_inline_and_lambda --args 15u8 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
