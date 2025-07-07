
//# publish
module 0xCAFE::CalcModule {
    // A module to test basic arithmetic and lambda expressions

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // return fixed value ignoring sum, just to test compute
        42u8
    }

    public fun call_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| {
            n * 2
        };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallsModule {
    use 0xCAFE::CalcModule;

    public fun nested_inline_call(a: u8, b: u8): u8 {
        let intermediate = CalcModule::inline_add(a, b);
        CalcModule::add_and_return_fixed(intermediate, 0u8)
    }

    public fun lambda_call_plus_one(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |val: u8| {
            val + 1
        };
        lambda(x)
    }
}


//# run 0xCAFE::CalcModule::add_and_return_fixed --args 10u8 15u8


//# run 0xCAFE::CalcModule::call_lambda --args 20u8


//# run 0xCAFE::NestedCallsModule::nested_inline_call --args 10u8 5u8


//# run 0xCAFE::NestedCallsModule::lambda_call_plus_one --args 41u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// fa1f0755c83c8b79f78255984c60ae82: Specify module names and ensure they do not start with an underscore.
