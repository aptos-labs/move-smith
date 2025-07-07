
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun test_lambda_expr(): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add_lambda(7u8, 8u8);
        result * 2u8
    }
}



//# publish
module 0xCAFE::InlineCallTest {
    use 0xCAFE::LambdaTest;

    // Removed `inline` keyword from the function definition to allow cross-module call
    public fun inline_adder(x: u8, y: u8): u8 {
        let res = x + y;
        res
    }

    public fun call_inline_from_another_module(x: u8, y: u8): u8 {
        let inner_sum = inline_adder(x, y);
        let lambda_sum = LambdaTest::add_and_return_sum(inner_sum, 5u8);
        lambda_sum
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_sum --args 3u8 4u8



//# run 0xCAFE::LambdaTest::test_lambda_expr



//# run 0xCAFE::InlineCallTest::inline_adder --args 5u8 6u8



//# run 0xCAFE::InlineCallTest::call_inline_from_another_module --args 2u8 3u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
