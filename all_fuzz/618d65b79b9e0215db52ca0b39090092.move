
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;

        let _ignore = if (sum > 0) {
            42
        } else {
            0
        };
        42
    }

    public fun test_lambda(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        lambda(7u8, 8u8)
    }

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun nested_call(x: u8, y: u8): u8 {
        let sum = LambdaTest::test_lambda(); // returns 15 from 7+8
        let twice = LambdaTest::inline_double(sum);
        LambdaTest::add_and_return_42(x, y);
        twice
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_42 --args 10u8 32u8


//# run 0xCAFE::LambdaTest::test_lambda


//# run 0xCAFE::NestedCall::nested_call --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
