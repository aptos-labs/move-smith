
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 5 just as a specific return value different from sum itself
        sum + 5
    }

    public fun lambda_example(a: u8, b: u8): (u8, u8) {
        let add_lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let s = x + y;
            let p = x * y;
            (s, p)
        };
        add_lambda(a, b)
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline(a: u8, b: u8): u8 {
        let (sum, product) = AddModule::lambda_example(a, b);
        // Call AddModule::add_and_return_sum with the sum from lambda
        AddModule::add_and_return_sum(sum, b)
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::AddModule::lambda_example --args 7u8 6u8


//# run 0xCAFE::CallerModule::call_inline --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
