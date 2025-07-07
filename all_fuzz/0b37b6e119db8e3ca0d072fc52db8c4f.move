
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_numbers(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            0u8
        };
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::LambdaTest::add_two_numbers --args 5u8 6u8


//# run 0xCAFE::LambdaTest::use_lambda --args 7u8 8u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public inline fun inline_adder(a: u8, b: u8): u8 {
        LambdaTest::use_lambda(a, b) + 1u8
    }

    public fun call_inline_from_nested(a: u8, b: u8): u8 {
        let sum = inline_adder(a, b);
        sum
    }
}


//# run 0xCAFE::NestedCall::call_inline_from_nested --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
