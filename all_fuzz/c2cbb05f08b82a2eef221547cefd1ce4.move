
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Returns 42u8 regardless, but we keep sum for check internally or debugger
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let f: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        f(x, y)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::LambdaTest::add_then_return --args 10u8 32u8


//# run 0xCAFE::LambdaTest::use_lambda --args 20u8 22u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::LambdaTest;

    public fun nested_inline_call(x: u8, y: u8): u8 {
        let sum = LambdaTest::inline_add(x, y);
        // Call again LambdaTest::add_then_return with sum and a constant for nested call coverage
        let _ = LambdaTest::add_then_return(sum, 1u8);
        sum
    }
}


//# run 0xCAFE::NestedCall::nested_inline_call --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
