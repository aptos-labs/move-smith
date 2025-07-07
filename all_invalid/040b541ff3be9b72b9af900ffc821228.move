
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            100u8
        } else {
            0u8
        }
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun nested_inline_call(a: u16): u16 {
        0xCAFE::InlineModule::inline_adder(a)
    }
}


//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_adder(a: u16): u16 {
        let inline_lambda: |u16| u16 has copy+drop = |x: u16| { x + 5 };
        inline_lambda(a + 1)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_special --args 7u8 3u8


//# run 0xCAFE::LambdaTest::add_and_return_special --args 2u8 3u8


//# run 0xCAFE::LambdaTest::apply_lambda --args 4u8 5u8


//# run 0xCAFE::LambdaTest::nested_inline_call --args 5u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
