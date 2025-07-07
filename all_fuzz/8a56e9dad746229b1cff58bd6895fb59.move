
//# publish
module 0xCAFE::MathOps {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let return_val = sum + 10;
        return_val
    }

    public fun test_lambda_with_addition(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_addition(x: u8): u8 {
        x + 5
    }
}


//# publish
module 0xCAFE::NestedCaller {
    use 0xCAFE::MathOps;

    public fun call_inline_add_and_add_two(a: u8, b: u8): u8 {
        let inline_result = MathOps::inline_addition(a);
        let sum = MathOps::add_two_values(inline_result, b);
        sum
    }
}


//# run 0xCAFE::MathOps::add_two_values --args 5u8 15u8


//# run 0xCAFE::MathOps::test_lambda_with_addition --args 7u8 8u8


//# run 0xCAFE::NestedCaller::call_inline_add_and_add_two --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
