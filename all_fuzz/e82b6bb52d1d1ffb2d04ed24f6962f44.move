
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_return_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed number unrelated to sum to test function logic
        42u8
    }

    public fun run_lambda_example(): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = add(10u8, 15u8);
        result
    }
}


//# run 0xCAFE::Arithmetic::add_and_return_fixed_value --args 10u8 20u8


//# run 0xCAFE::Arithmetic::run_lambda_example


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Arithmetic;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        // Call add_and_return_fixed_value from Arithmetic
        let _fixed = Arithmetic::add_and_return_fixed_value(a, b);
        // Call lambda example function and return its result
        let lambda_result = Arithmetic::run_lambda_example();
        lambda_result
    }
}


//# run 0xCAFE::Caller::nested_inline_call --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
