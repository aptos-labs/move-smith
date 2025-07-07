
//# publish
module 0xCAFE::CalcModule {
    // Module to implement addition and lambda expressions

    public fun add_two_numbers(a: u8, b: u8): u8 {
        // Compute sum and return sum + 10
        let sum = a + b;
        sum + 10
    }

    public fun lambda_test(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        let result = add(x, y);
        result
    }

    public inline fun inline_addition(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    public fun call_add_two_numbers(a: u8, b: u8): u8 {
        CalcModule::add_two_numbers(a, b)
    }

    public fun call_lambda_test(x: u8, y: u8): u8 {
        CalcModule::lambda_test(x, y)
    }

    public fun call_inline_addition(x: u8, y: u8): u8 {
        // Calling inline function from CalcModule and then calling add_two_numbers with the result and a constant
        let partial_sum = CalcModule::inline_addition(x, y);
        CalcModule::add_two_numbers(partial_sum, 5u8)
    }
}


//# run 0xCAFE::CalcModule::add_two_numbers --args 5u8 7u8


//# run 0xCAFE::CalcModule::lambda_test --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_add_two_numbers --args 10u8 20u8


//# run 0xCAFE::CallerModule::call_lambda_test --args 6u8 9u8


//# run 0xCAFE::CallerModule::call_inline_addition --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
