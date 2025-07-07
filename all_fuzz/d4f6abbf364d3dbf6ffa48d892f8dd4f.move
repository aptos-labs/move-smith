
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Add 10 to the sum before returning
        sum + 10
    }

    public fun apply_lambda_to_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let lambda: |u8|u8 has copy+drop = |x: u8| { x + 5u8 };
        lambda(sum)
    }
}


//# publish
module 0xCAFE::NestedInlineCall {
    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_increment_twice(x: u8): u8 {
        let first = inline_increment(x);
        inline_increment(first)
    }
}


//# publish
module 0xCAFE::CallNestedInline {
    use 0xCAFE::NestedInlineCall;

    public fun execute_nested_calls(x: u8): u8 {
        NestedInlineCall::call_inline_increment_twice(x)
    }
}


//# run 0xCAFE::AddAndLambda::add_u8_values --args 5u8 7u8


//# run 0xCAFE::AddAndLambda::apply_lambda_to_sum --args 4u8 6u8


//# run 0xCAFE::CallNestedInline::execute_nested_calls --args 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
