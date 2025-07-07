
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = add_lambda(a, b);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedModule {
    use 0xCAFE::LambdaTest;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let x = LambdaTest::inline_add(a, b);
        let y = LambdaTest::add_and_return_sum(x, 5u8);
        y
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::LambdaTest::use_lambda --args 7u8 8u8


//# run 0xCAFE::NestedModule::nested_inline_call --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
