
//# publish
module 0xCAFE::LambdaTest {
    // Module to test lambda expressions and addition functionality

    public fun add_two_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun test_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(7u8, 8u8)
    }
}


//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let sum = LambdaTest::add_two_u8(x, y);
        let incremented = inline_increment(sum);
        incremented
    }
}


//# run 0xCAFE::LambdaTest::add_two_u8 --args 10u8 15u8


//# run 0xCAFE::LambdaTest::test_lambda


//# run 0xCAFE::InlineCall::call_nested_functions --args 20u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
