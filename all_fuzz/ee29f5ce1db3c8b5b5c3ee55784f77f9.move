
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun with_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| { v + 1u8 };
        lambda(x)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u8, b: u8): u8 {
        let _ = LambdaTest::with_lambda(1u8);
        a + b
    }

    public fun call_inline_add(): u8 {
        inline_add(10u8, 20u8)
    }
}


//# run 0xCAFE::LambdaTest::add_u8_return_42 --args 5u8 7u8


//# run 0xCAFE::LambdaTest::with_lambda --args 10u8


//# run 0xCAFE::InlineCaller::call_inline_add


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
