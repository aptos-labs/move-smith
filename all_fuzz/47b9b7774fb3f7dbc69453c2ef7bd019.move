
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus some constant 10
        sum + 10
    }

    public fun lambda_adder(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(5u8, 7u8)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_sum(x: u8, y: u8): u8 {
        // Call AddModule::add_and_return_sum and add an extra 5 to result
        let tmp = AddModule::add_and_return_sum(x, y);
        tmp + 5
    }

    public fun call_lambda_adder(): u8 {
        AddModule::lambda_adder()
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::AddModule::lambda_adder


//# run 0xCAFE::CallerModule::call_add_and_sum --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_lambda_adder


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
