
//# publish
module 0xCAFE::AddAndLambda {
    use std::signer;

    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) { 42 } else { 0 };
        result
    }

    public fun test_lambda(x: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, 5u8)
    }
}


//# run 0xCAFE::AddAndLambda::add_two --args 6u8 7u8


//# run 0xCAFE::AddAndLambda::test_lambda --args 3u8


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddAndLambda;

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }

    public fun call_add_two_and_inline(x: u8, y: u8): (u8, u8) {
        let call_add = AddAndLambda::add_two(x, y);
        let call_inline = inline_adder(x, y);
        (call_add, call_inline)
    }
}


//# run 0xCAFE::CallInline::call_add_two_and_inline --args 7u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
