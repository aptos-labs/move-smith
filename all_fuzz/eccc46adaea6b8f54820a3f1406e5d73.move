
//# publish
module 0xCAFE::AddModule {
    // Module for testing addition of two u8 values and returning a specific value
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value 42u8 after addition (for testing purpose)
        42u8
    }

    public fun call_lambda_with_capture(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(a, b);
        result
    }

    public fun call_lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 10u8 20u8


//# run 0xCAFE::AddModule::call_lambda_with_capture --args 15u8 27u8


//# run 0xCAFE::AddModule::call_lambda_return_tuple --args 3u8 6u8


//# publish
module 0xCAFE::InlineCallModule {
    use 0xCAFE::AddModule;

    /// Calls AddModule::add_and_return inline and then calls call_lambda_with_capture inline,
    /// finally returns the sum of both results.
    public fun nested_inline_calls(a: u8, b: u8): u8 {
        let res1 = AddModule::add_and_return(a, b);
        let res2 = AddModule::call_lambda_with_capture(a, b);
        res1 + res2
    }

    /// Calls AddModule::call_lambda_return_tuple inline, extracts tuple and returns sum and product added
    public fun call_and_process_tuple(a: u8, b: u8): u8 {
        let (s, p) = AddModule::call_lambda_return_tuple(a, b);
        s + p
    }
}


//# run 0xCAFE::InlineCallModule::nested_inline_calls --args 5u8 7u8


//# run 0xCAFE::InlineCallModule::call_and_process_tuple --args 4u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
