
//# publish
module 0xCAFE::AdditionTest {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_example(x: u8): (u8, u8) {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        let doubled = lambda(x);
        (x, doubled)
    }
}


//# run 0xCAFE::AdditionTest::add_then_return_sum --args 10u8 20u8


//# run 0xCAFE::AdditionTest::lambda_example --args 5u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AdditionTest;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_nested_inline(x: u8, y: u8): u8 {
        // call inline function from this module
        let inc_x = inline_increment(x);

        // call function from AdditionTest module
        let sum = AdditionTest::add_then_return_sum(inc_x, y);

        sum
    }
}


//# run 0xCAFE::NestedInlineCall::call_nested_inline --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 41f8c7258935ea12ed715b21888bd747: Assign an expression to a named variable using a 'let' binding in Move.
// 120156d5799c0de361f56ba5a6d58f27: Generate interface files from compiled Move modules
