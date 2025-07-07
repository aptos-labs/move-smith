
//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_specific_value(x: u8, y: u8): u8 {
        let sum = x + y;
        42u8 + sum
    }

    public fun call_lambda_with_args(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            let d = a * b;
            (c, d)
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AdditionTest::add_and_return_specific_value --args 10u8 5u8


//# run 0xCAFE::AdditionTest::call_lambda_with_args --args 7u8 3u8


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AdditionTest;

    public inline fun inline_add_a_b(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_nested_add(x: u8, y: u8): u8 {
        let sum_inner = inline_add_a_b(x, y);
        let sum_outer = AdditionTest::add_and_return_specific_value(sum_inner, 5u8);
        sum_outer
    }
}


//# run 0xCAFE::NestedCall::call_nested_add --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
