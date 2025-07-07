
//# publish
module 0xCAFE::AddTest {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun lambda_chain(val: u8): u8 {
        let mul_lambda: |u8|u8 has copy+drop = |x: u8| { x * 2 };
        let add_lambda: |u8|u8 has copy+drop = |x: u8| { x + 3 };
        add_lambda(mul_lambda(val))
    }
}


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddTest;

    public inline fun inline_double(a: u8): u8 {
        a * 2
    }

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let inline_result = inline_double(a);
        let external_sum = AddTest::add_and_return_fixed(inline_result, b);
        external_sum
    }

    public fun call_nested_inline(a: u8): u8 {
        AddTest::lambda_chain(a) + inline_double(a)
    }
}


//# run 0xCAFE::AddTest::add_and_return_fixed --args 5u8 10u8


//# run 0xCAFE::AddTest::lambda_add --args 7u8 8u8


//# run 0xCAFE::AddTest::lambda_chain --args 4u8


//# run 0xCAFE::CallInline::call_inline_and_add --args 3u8 5u8


//# run 0xCAFE::CallInline::call_nested_inline --args 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
