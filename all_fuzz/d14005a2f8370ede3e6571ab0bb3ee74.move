
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42
        } else {
            7
        }
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 = |x: u8, y: u8| x + y;
        lambda(a, b)
    }

    public fun run_lambda_chain(): u8 {
        let lambda1: |u8| u8 = |x: u8| x + 1;
        let lambda2: |u8| u8 = |x: u8| lambda1(x) * 2;
        lambda2(3u8)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_function(a: u8, b: u8): u8 {
        // Call use_lambda that uses lambda expression defined in AddModule
        let result = AddModule::use_lambda(a, b);

        // Call a function that calls inline functions internally
        let chain_result = AddModule::run_lambda_chain();

        result + chain_result
    }
}



//# run 0xCAFE::AddModule::add_then_return --args 5u8 7u8



//# run 0xCAFE::AddModule::add_then_return --args 3u8 4u8



//# run 0xCAFE::AddModule::use_lambda --args 10u8 5u8



//# run 0xCAFE::AddModule::run_lambda_chain



//# run 0xCAFE::CallerModule::call_inline_function --args 10u8 20u8


// Features:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
