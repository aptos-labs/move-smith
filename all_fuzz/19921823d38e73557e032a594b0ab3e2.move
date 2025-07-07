
//# publish
module 0xCAFE::AddModule {
    // A module to test simple addition and return fixed value

    public fun add_then_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        let fixed_value = 42u8;
        // Using sum only to do something (no assert, just logic)
        sum + 0u8;
        fixed_value
    }

    // Function with lambda: takes two u8 and returns their product as u8
    public fun lambda_multiply(x: u8, y: u8): u8 {
        let multiplier = |a: u8, b: u8| {
            a * b
        };
        multiplier(x, y)
    }
}


//# run 0xCAFE::AddModule::add_then_return_fixed --args 15u8 27u8


//# run 0xCAFE::AddModule::lambda_multiply --args 6u8 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Function that calls inline addition from AddModule via a nested call
    public inline fun inline_addition(a: u8, b: u8): u8 {
        AddModule::add_then_return_fixed(a, b)
    }

    public fun call_nested_inline(): u8 {
        let res = inline_addition(10u8, 32u8);
        res
    }

    // Function with lambda that calls AddModule's lambda_multiply inside
    public fun lambda_calls_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 = |a: u8, b: u8| {
            AddModule::lambda_multiply(a, b)
        };
        lambda(x, y)
    }
}


//# run 0xCAFE::CallerModule::call_nested_inline


//# run 0xCAFE::CallerModule::lambda_calls_lambda --args 3u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
