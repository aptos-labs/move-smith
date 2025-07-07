
//# publish
module 0xCAFE::MathModule {
    // A simple function to add two u8 numbers then return a fixed value
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _fixed_value = 42u8;
        _fixed_value
    }

    // A function containing lambda expressions to add and multiply two u8 numbers
    public fun lambda_operations(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8| (u8) has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let multiply_lambda: |u8, u8| (u8) has copy + drop = |x: u8, y: u8| {
            x * y
        };
        let result_add = add_lambda(a, b);
        let result_mul = multiply_lambda(a, b);
        (result_add, result_mul)
    }

    // Corrected: remove 'inline' keyword (not valid syntax in Move)
    public fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCall {
    // Use module with the full name syntax as defined above
    use 0xCAFE::MathModule;

    // Call inline function from MathModule and add extra value to the result
    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let inline_result = MathModule::inline_addition(a, b);
        inline_result + 10u8
    }

    // Runner function to call lambda_operations from MathModule with fixed args
    public fun run_lambda_operations(): (u8, u8) {
        MathModule::lambda_operations(5u8, 7u8)
    }
}



//# run 0xCAFE::MathModule::add_then_return_fixed --args 20u8 22u8



//# run 0xCAFE::MathModule::lambda_operations --args 3u8 4u8



//# run 0xCAFE::NestedCall::call_inline_and_add --args 15u8 25u8



//# run 0xCAFE::NestedCall::run_lambda_operations


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
