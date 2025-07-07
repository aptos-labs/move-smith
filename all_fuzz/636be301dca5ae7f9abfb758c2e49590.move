
//# publish
module 0xCAFE::MathOps {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42 regardless of sum
        42u8
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let sum = 0xCAFE::MathOps::inline_add(a, b);
        // use nested inline call
        let doubled = inline_add(sum, sum);
        doubled
    }
}


//# run 0xCAFE::MathOps::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::MathOps::lambda_example --args 15u8 25u8


//# run 0xCAFE::MathOps::nested_inline_call --args 5u8 10u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
