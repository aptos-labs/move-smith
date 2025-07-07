
//# publish
module 0xCAFE::AddU8 {
    public fun add_two_values_and_check(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == x + y) {
            42u8
        } else {
            0u8
        }
    }

    public fun run_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddU8::add_two_values_and_check --args 10u8 20u8


//# run 0xCAFE::AddU8::run_lambda_example --args 15u8 25u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddU8;

    // Call nested inline function from AddU8
    public fun test_nested_calls(x: u8, y: u8): u8 {
        let sum = AddU8::add_two_values_and_check(x, y);
        let lambda_result = AddU8::run_lambda_example(x, y);
        sum + lambda_result
    }
}


//# run 0xCAFE::NestedCalls::test_nested_calls --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
