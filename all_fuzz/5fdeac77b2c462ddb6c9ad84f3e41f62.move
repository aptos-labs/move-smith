
//# publish
module 0xCAFE::CalcModule {
    // Simple addition function that returns sum + 10u8
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    // Function with lambda to multiply two numbers and add 5
    public fun lambda_test(a: u8, b: u8): u8 {
        let multiply_then_add = |x: u8, y: u8| {
            let product = x * y;
            product + 5u8
        };
        multiply_then_add(a, b)
    }
}


//# run 0xCAFE::CalcModule::add_and_offset --args 3u8 4u8


//# run 0xCAFE::CalcModule::lambda_test --args 2u8 5u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::CalcModule;

    // Calls CalcModule::add_and_offset and then calls CalcModule::lambda_test internally
    public fun nested_calls(a: u8, b: u8): (u8, u8) {
        let offset_result = CalcModule::add_and_offset(a, b);
        let lambda_result = CalcModule::lambda_test(a, b);
        (offset_result, lambda_result)
    }
}


//# run 0xCAFE::CallerModule::nested_calls --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
