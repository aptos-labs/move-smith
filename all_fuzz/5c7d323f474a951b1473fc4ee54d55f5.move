
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and returning a fixed u8 value
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed: u8 = 42;
        // Use sum in some way to prevent optimization out
        if (sum > 0) {
            fixed
        } else {
            0u8
        }
    }

    // Function containing a lambda that doubles a u8 value and adds a constant
    public fun lambda_double_plus_const(x: u8): u8 {
        let double_and_add = |v: u8| {
            let doubled = v + v;
            doubled + 3u8
        };
        double_and_add(x)
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return_fixed --args 10u8 32u8



//# run 0xCAFE::AddAndLambda::lambda_double_plus_const --args 5u8



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::AddAndLambda;

    // Inline function returning (a + 1, a + 2)
    public inline fun inline_increment_pair(a: u8): (u8, u8) {
        (a + 1, a + 2)
    }

    // Function calling an inline function of another module, combining the results, and returning
    public fun call_other_module_inline_and_compute(x: u8): u8 {
        // Correct approach:
        // Call lambda_double_plus_const to get u8 value
        let val = AddAndLambda::lambda_double_plus_const(x);
        // Call inline_increment_pair locally with the value from other module
        let (inc1, inc2) = inline_increment_pair(val);
        // Return sum of returned tuple components as u8
        inc1 + inc2
    }

    // Helper function without external call to call inline function in this module
    public fun inline_return_tuple(a: u8): (u8, u8) {
        inline_increment_pair(a)
    }
}



//# run 0xCAFE::NestedInlineCall::call_other_module_inline_and_compute --args 5u8



//# run 0xCAFE::NestedInlineCall::inline_return_tuple --args 10u8

// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
