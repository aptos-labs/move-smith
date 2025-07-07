
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            10u8
        };
        99u8
    }

    public fun call_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |y: u8| { y * 2 };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::LambdaTest;

    public fun call_nested_inline(a: u8, b: u8, c: u8): u8 {
        let s = LambdaTest::inline_add(a, b);
        let total = LambdaTest::inline_add(s, c);
        total
    }
}


//# run 0xCAFE::LambdaTest::add_and_return --args 4u8 7u8


//# run 0xCAFE::LambdaTest::add_and_return --args 1u8 2u8


//# run 0xCAFE::LambdaTest::call_lambda --args 21u8


//# run 0xCAFE::NestedInlineCaller::call_nested_inline --args 1u8 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
