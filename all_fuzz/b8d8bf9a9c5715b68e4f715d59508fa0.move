
//# publish
module 0xCAFE::LambdaAndInline {
    use std::signer;

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add(x: u8, y: u8): u8 {
        // Call inline function and add 1 to the result
        let result = inline_add(x, y) + 1;
        result
    }

    public fun lambda_add_and_mul(x: u8, y: u8): (u8, u8) {
        let add_and_mul: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        add_and_mul(x, y)
    }

    public fun lambda_capture_value(x: u8): u8 {
        let captured = 5u8;
        let add_captured: |u8|u8 has copy+drop = |a: u8| {
            a + captured
        };
        add_captured(x)
    }
}


//# run 0xCAFE::LambdaAndInline::call_inline_add --args 10u8 15u8


//# run 0xCAFE::LambdaAndInline::lambda_add_and_mul --args 3u8 7u8


//# run 0xCAFE::LambdaAndInline::lambda_capture_value --args 20u8


//# publish
module 0xCAFE::InlineUsage {
    use 0xCAFE::LambdaAndInline;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        // Call inline function from another module via wrapper function
        let res = LambdaAndInline::call_inline_add(a, b);
        // Add 2 to the result from LambdaAndInline::call_inline_add
        res + 2
    }
}


//# run 0xCAFE::InlineUsage::nested_inline_call --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
