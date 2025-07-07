
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        let _lambda: |u8| u8 = |x: u8| x + sum;
        let intermediate = _lambda(0);
        intermediate + 42
    }

    public inline fun inline_addition(x: u8, y: u8): u8 {
        let result = x + y;
        result
    }

    public fun use_inline_from_another(x: u8, y: u8): u8 {
        let z = 0xCAFE::LambdaTest::inline_addition(x, y);
        z + 10
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaTest;

    public fun nested_call(x: u8, y: u8): u8 {
        let sum = LambdaTest::add_then_constant(x, y);
        let inline_result = LambdaTest::inline_addition(x, y);
        sum + inline_result
    }
}


//# run 0xCAFE::LambdaTest::add_then_constant --args 3u8 5u8


//# run 0xCAFE::LambdaTest::use_inline_from_another --args 4u8 6u8


//# run 0xCAFE::CallerModule::nested_call --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
