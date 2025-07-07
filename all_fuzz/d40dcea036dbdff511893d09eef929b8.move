
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(x: u8, y: u8, return_val: u8): u8 {
        let sum = x + y;
        let _ignore = sum;
        return_val
    }

    public fun call_lambda_return_result(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            let s = a + b;
            s
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::AddAndReturn::add_and_return --args 10u8 20u8 42u8


//# run 0xCAFE::AddAndReturn::call_lambda_return_result --args 15u8 25u8


//# publish
module 0xCAFE::CallInlineFunction {
    use 0xCAFE::AddAndReturn;

    public inline fun inline_sum_plus_one(x: u8, y: u8): u8 {
        let sum = AddAndReturn::call_lambda_return_result(x, y);
        sum + 1
    }

    public fun runner(): u8 {
        inline_sum_plus_one(5u8, 6u8)
    }
}


//# run 0xCAFE::CallInlineFunction::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
