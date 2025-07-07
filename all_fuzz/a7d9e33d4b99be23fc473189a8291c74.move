
//# publish
module 0xCAFE::NestedInline {
    public inline fun add_one_and_two(a: u8): (u8, u8) {
        (a + 1, a + 2)
    }

    public fun call_inline(x: u8): u8 {
        let (a, b) = add_one_and_two(x);
        a + b
    }
}


//# publish
module 0xCAFE::LambdaTest {
    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        lambda(x, y)
    }

    public fun call_other_module_add(x: u8): u8 {
        0xCAFE::NestedInline::call_inline(x)
    }
}


//# run 0xCAFE::LambdaTest::use_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaTest::call_other_module_add --args 5u8


//# run 0xCAFE::NestedInline::call_inline --args 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
