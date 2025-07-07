
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::InlineWrapper {
    use 0xCAFE::LambdaTest;

    public inline fun inline_addition(a: u8, b: u8): u8 {
        let result = LambdaTest::add_two_values(a, b);
        result
    }

    public fun nested_call(a: u8, b: u8): u8 {
        inline_addition(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 5u8 7u8


//# run 0xCAFE::LambdaTest::use_lambda --args 8u8 9u8


//# run 0xCAFE::InlineWrapper::nested_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
