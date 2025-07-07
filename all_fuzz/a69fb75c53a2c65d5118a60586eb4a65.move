
//# publish
module 0xCAFE::AddAndReturnValue {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return the sum + 10 to test addition and return
        sum + 10
    }

    public fun lambda_add_and_multiply(): (u8, u8) {
        let add_mul_lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        add_mul_lambda(4u8, 5u8)
    }
}


//# run 0xCAFE::AddAndReturnValue::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::AddAndReturnValue::lambda_add_and_multiply



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndReturnValue;

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_add_and_inline(a: u8, b: u8): u8 {
        let sum = AddAndReturnValue::add_and_return_sum(a, b);
        let result = inline_increment(sum);
        result
    }

    public fun call_lambda_from_other_module(): (u8, u8) {
        // Call lambda function indirectly by calling the function in AddAndReturnValue module
        AddAndReturnValue::lambda_add_and_multiply()
    }
}


//# run 0xCAFE::NestedCalls::call_add_and_inline --args 3u8 4u8


//# run 0xCAFE::NestedCalls::call_lambda_from_other_module


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
