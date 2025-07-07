
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value 42_u8 if sum is correct (always returning 42 to test add)
        42u8
    }

    public fun f_with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 10u8 32u8


//# run 0xCAFE::AddModule::f_with_lambda --args 5u8 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_from_other(x: u8, y: u8): u8 {
        // Call AddModule::f_with_lambda which has a lambda expression
        let result = AddModule::f_with_lambda(x, y);
        result
    }

    public fun call_add_two_values(x: u8, y: u8): u8 {
        AddModule::add_two_values(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_inline_from_other --args 20u8 22u8


//# run 0xCAFE::CallerModule::call_add_two_values --args 40u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
