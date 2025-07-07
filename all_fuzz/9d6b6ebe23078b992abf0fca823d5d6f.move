
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return(x: u8, y: u8, return_value: u8): u8 {
        let sum = x + y;
        let _ = sum; // use sum to verify computation happens
        return_value
    }

    public fun add_with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_then_return --args 3u8 4u8 99u8


//# run 0xCAFE::AddModule::add_with_lambda --args 10u8 20u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(): u16 {
        let a = 5u16;
        let b = 15u16;
        let result = AddModule::inline_add(a, b);
        result
    }

    public fun nested_call(a: u8, b: u8): u8 {
        // Call add_then_return with sum of a and b, return a specific value 42
        let res = AddModule::add_then_return(a, b, 42u8);
        res
    }

    public fun lambda_caller(a: u8, b: u8): u8 {
        AddModule::add_with_lambda(a, b)
    }
}


//# run 0xCAFE::CallerModule::call_inline_add


//# run 0xCAFE::CallerModule::nested_call --args 8u8 7u8


//# run 0xCAFE::CallerModule::lambda_caller --args 9u8 11u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
