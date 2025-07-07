
//# publish
module 0xCAFE::AddModule {
    // Module for adding two u8 and returning a fixed u8 value after

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed_value = 42u8;
        // return fixed_value ignoring sum, but sum computed internally
        fixed_value
    }

    public fun with_lambda_return_sum(a: u8, b: u8): u8 {
        let add_fn: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_fn(a, b)
    }

    public fun with_lambda_return_product(a: u8, b: u8): u8 {
        let mul_fn: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        mul_fn(a, b)
    }

    public inline fun inline_sum(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 5u8 10u8


//# run 0xCAFE::AddModule::with_lambda_return_sum --args 7u8 8u8


//# run 0xCAFE::AddModule::with_lambda_return_product --args 4u8 3u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_sum(a: u8, b: u8): u8 {
        // calls inline function from AddModule
        AddModule::inline_sum(a, b)
    }

    public fun call_with_lambda_sum(a: u8, b: u8): u8 {
        // calls function with lambda from AddModule
        AddModule::with_lambda_return_sum(a, b)
    }

    public fun call_add_and_return_fixed(a: u8, b: u8): u8 {
        // calls function that computes sum and returns fixed
        AddModule::add_and_return_fixed(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_inline_sum --args 10u8 20u8


//# run 0xCAFE::CallerModule::call_with_lambda_sum --args 15u8 25u8


//# run 0xCAFE::CallerModule::call_add_and_return_fixed --args 50u8 60u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 475cd32e93a90a6dfa812a8bbfdc6ae3: Process package definitions to register modules, their addresses, and deprecation information within the compiler context.
