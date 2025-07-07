
//# publish
module 0xCAFE::AddAndCompute {
    /// Adds two u8 numbers and returns the sum plus a fixed offset (5)
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Returns the result of applying a lambda function to two u8 inputs.
    /// The lambda doubles the sum of the inputs.
    public fun lambda_double_sum(a: u8, b: u8): u8 {
        let double_sum_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            s * 2
        };
        double_sum_lambda(a, b)
    }
}


//# run 0xCAFE::AddAndCompute::add_and_offset --args 10u8 20u8


//# run 0xCAFE::AddAndCompute::lambda_double_sum --args 4u8 6u8


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AddAndCompute;

    /// Calls the inline add_and_offset function in AddAndCompute multiple times,
    /// adding the results together, returning the final sum.
    public fun call_add_and_offset_multiple_times(x: u8, y: u8): u8 {
        let r1 = AddAndCompute::add_and_offset(x, y);
        let r2 = AddAndCompute::add_and_offset(r1, 1u8);
        let r3 = AddAndCompute::add_and_offset(r2, 1u8);
        r1 + r2 + r3
    }

    /// Calls the lambda_double_sum function from AddAndCompute and adds 3 to the result.
    public fun call_lambda_and_add(x: u8, y: u8): u8 {
        let v = AddAndCompute::lambda_double_sum(x, y);
        v + 3
    }
}


//# run 0xCAFE::NestedInlineCaller::call_add_and_offset_multiple_times --args 1u8 2u8


//# run 0xCAFE::NestedInlineCaller::call_lambda_and_add --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
