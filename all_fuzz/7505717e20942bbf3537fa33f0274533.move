
//# publish
module 0xCAFE::CalcModule {
    // A simple addition function that returns sum plus 10
    public fun add_then_plus_ten(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10
    }

    // A function containing a lambda that multiplies two u8 numbers and adds an offset
    public fun lambda_multiply_add(x: u8, y: u8): u8 {
        let multiplier: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let product = multiplier(x, y);
        product + 5
    }

    // Runner function without arguments to exercise lambda_multiply_add
    public fun run_lambda() {
        let _ = lambda_multiply_add(3u8, 4u8);
    }
}


//# run 0xCAFE::CalcModule::add_then_plus_ten --args 7u8 8u8


//# run 0xCAFE::CalcModule::lambda_multiply_add --args 2u8 5u8


//# run 0xCAFE::CalcModule::run_lambda


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::CalcModule;

    // Inline function calling an inline function from CalcModule
    public fun call_add_then_plus_ten_nested(x: u8, y: u8): u8 {
        let intermediate = CalcModule::add_then_plus_ten(x, y);
        // Call again with intermediate and fixed value 1, testing nested function calls
        CalcModule::add_then_plus_ten(intermediate, 1u8)
    }

    // Runner function to call the nested function calls without arguments
    public fun run_nested_calls() {
        let _ = call_add_then_plus_ten_nested(1u8, 2u8);
    }
}


//# run 0xCAFE::InlineCaller::call_add_then_plus_ten_nested --args 10u8 20u8


//# run 0xCAFE::InlineCaller::run_nested_calls


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
