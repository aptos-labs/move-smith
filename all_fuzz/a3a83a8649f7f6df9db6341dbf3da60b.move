
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y + 1u8
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::LambdaTest;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let res = LambdaTest::inline_add(a, b);
        res + 5u8
    }

    public fun runner() {
        let _ = call_inline_add(3u8, 4u8);
        let _ = LambdaTest::add_u8(1u8, 2u8);
        let _ = LambdaTest::with_lambda(2u8, 3u8);
    }
}


//# run 0xCAFE::LambdaTest::add_u8 --args 5u8 7u8


//# run 0xCAFE::LambdaTest::with_lambda --args 3u8 6u8


//# run 0xCAFE::NestedCaller::call_inline_add --args 10u8 20u8


//# run 0xCAFE::NestedCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
