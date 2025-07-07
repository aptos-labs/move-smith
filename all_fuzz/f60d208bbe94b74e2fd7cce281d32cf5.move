
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        // We want to test if sum is correctly computed and used.
        if (sum == 10) {
            42u8
        } else {
            43u8
        }
    }

    public fun returns_lambda(): |u8, u8| u8 {
        // Returns a lambda that adds two numbers and multiplies sum by 2
        |x: u8, y: u8| {
            let s = x + y;
            s * 2
        }
    }

    public fun call_lambda_with_args(x: u8, y: u8): u8 {
        let lambda = returns_lambda();
        lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_and_return_special --args 4u8 6u8


//# run 0xCAFE::AddModule::add_and_return_special --args 2u8 3u8


//# run 0xCAFE::AddModule::call_lambda_with_args --args 3u8 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_func_twice(a: u8, b: u8): u8 {
        // Calls AddModule::add_and_return_special twice and add the results
        let r1 = AddModule::add_and_return_special(a, b);
        let r2 = AddModule::add_and_return_special(b, a);
        r1 + r2
    }

    public fun call_lambda_from_other_module(x: u8, y: u8): u8 {
        let lambda = AddModule::returns_lambda();
        lambda(x, y)
    }

    public fun nested_call_inline(x: u8, y: u8): u8 {
        // Calls call_inline_func_twice inside this module
        call_inline_func_twice(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_inline_func_twice --args 4u8 6u8


//# run 0xCAFE::CallerModule::call_lambda_from_other_module --args 5u8 10u8


//# run 0xCAFE::CallerModule::nested_call_inline --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
