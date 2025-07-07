
//# publish
module 0xCAFE::AddModule {
    // Test computing addition of two u8 values and return a specific value
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 5 to have a specific offset result
        sum + 5
    }

    // Function containing lambda expression that returns multiplier of input by 2
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8|u8 has copy+drop = |a: u8| {
            a * 2u8
        };
        doubler(x)
    }

    // Function containing lambda which captures and modifies outer variable
    public fun increment_and_apply_lambda(x: u8): u8 {
        let val = x;
        let incrementer: |u8|u8 has copy+drop = |a: u8| {
            a + 1u8
        };
        val = incrementer(val);
        val
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 10u8 15u8


//# run 0xCAFE::AddModule::double_with_lambda --args 7u8


//# run 0xCAFE::AddModule::increment_and_apply_lambda --args 8u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_return_result(x: u8, y: u8): u8 {
        // Call AddModule::add_and_return with (x,y)
        let result1 = AddModule::add_and_return(x, y);
        // Call AddModule::double_with_lambda with the result1
        let result2 = AddModule::double_with_lambda(result1);
        result2
    }
}


//# run 0xCAFE::CallerModule::call_inline_and_return_result --args 4u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
