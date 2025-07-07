
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // return fixed value 42u8 after addition to test computation before return
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AdditionModule::use_lambda --args 15u8 27u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AdditionModule::inline_add(a, b)
    }

    public fun call_lambda_and_add(a: u8, b: u8): u8 {
        let result_lambda = AdditionModule::use_lambda(a, b);
        let result_inline = AdditionModule::inline_add(result_lambda, 1u8);
        result_inline
    }

    public fun runner() {
        let _ = call_inline_add(3u8, 4u8);
        let _ = call_lambda_and_add(5u8, 10u8);
    }
}


//# run 0xCAFE::CallerModule::call_inline_add --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_lambda_and_add --args 5u8 10u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
