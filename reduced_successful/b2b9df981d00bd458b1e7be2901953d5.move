
//# publish
module 0xCAFE::CalcModule {
    // Module to test addition and lambdas

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = 42u8;
        // just return 42 after computation to test logic separation
        result
    }

    public fun apply_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = adder(a, b);
        sum
    }
}


//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::CalcModule;

    // Inline function that returns a (u8, u8) tuple
    public inline fun inline_sum_and_diff(a: u8, b: u8): (u8, u8) {
        let sum = a + b;
        let diff = a; // just dummy difference
        (sum, diff)
    }

    public fun call_nested_functions(a: u8, b: u8): u8 {
        let (sum, _) = inline_sum_and_diff(a, b);
        let lambda_sum = CalcModule::apply_lambda(a, b);
        let final = sum + lambda_sum;
        final
    }
}


//# run 0xCAFE::CalcModule::add_two_values --args 7u8 8u8


//# run 0xCAFE::CalcModule::apply_lambda --args 5u8 10u8


//# run 0xCAFE::CallInlineModule::call_nested_functions --args 5u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
