
//# publish
module 0xCAFE::ComputeAdd {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 irrespective of sum to test computation correctness
        42u8
    }

    public fun do_lambda_computation(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        let multiply_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a * b };
        let add_result = add_lambda(x, y);
        let mul_result = multiply_lambda(x, y);
        add_result + mul_result
    }
}


//# run 0xCAFE::ComputeAdd::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::ComputeAdd::do_lambda_computation --args 7u8 3u8


//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::ComputeAdd;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun nested_calls(a: u8, b: u8): u8 {
        let incremented = inline_increment(a);
        let add_fixed = ComputeAdd::add_and_return_fixed(incremented, b);
        add_fixed
    }
}


//# run 0xCAFE::NestedInlineCall::nested_calls --args 40u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
