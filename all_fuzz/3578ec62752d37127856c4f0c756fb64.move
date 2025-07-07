
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let result = a + b;
        // Return result + 10 to have a specific value different from just sum
        result + 10
    }

    public fun lambda_example(a: u8): u8 {
        let increment: |u8| u8 has copy+drop = |x: u8| {
            x + 1
        };
        increment(a)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 7u8


//# run 0xCAFE::AddModule::lambda_example --args 9u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_two_values(a: u8, b: u8): u8 {
        AddModule::add_two_values(a, b)
    }

    public fun call_lambda_example(a: u8): u8 {
        AddModule::lambda_example(a)
    }
}


//# run 0xCAFE::CallerModule::call_add_two_values --args 20u8 15u8


//# run 0xCAFE::CallerModule::call_lambda_example --args 100u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
