
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8
    }

    public fun test_lambda_usage(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        lambda(10u8, 20u8)
    }

    public fun runner(): u8 {
        let res = add_and_return_fixed(1u8, 2u8);
        let lambda_res = test_lambda_usage();
        res + lambda_res
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 7u8 35u8


//# run 0xCAFE::AddModule::test_lambda_usage


//# run 0xCAFE::AddModule::runner



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_function(): u8 {
        let inline_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            sum
        };
        let first_call = inline_lambda(2u8, 3u8);
        let nested_call = AddModule::test_lambda_usage();
        first_call + nested_call
    }

    public fun runner_nested_call(): u8 {
        call_inline_function()
    }
}


//# run 0xCAFE::CallerModule::call_inline_function


//# run 0xCAFE::CallerModule::runner_nested_call


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 127fdbb7d820b0c1d016477575c50ee0: Wrap address definitions with their modules into updated address definitions after extraction.
