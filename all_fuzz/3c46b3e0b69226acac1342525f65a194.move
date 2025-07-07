
//# publish
module 0xCAFE::AddModule {

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Always return 42u8 regardless of sum - testing computation before return
        42u8
    }

    public fun test_lambda_expr(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = adder(x, y);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun lets_with_shadowing(x: u64): u64 {
        let x = x + 10u64;
        let x = x * 2u64;
        let x = x - 5u64;
        x
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AddModule::inline_add(a, b)
    }

    public fun call_add_and_return_fixed(a: u8, b: u8): u8 {
        AddModule::add_and_return_fixed(a, b)
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddModule::test_lambda_expr --args 15u8 25u8


//# run 0xCAFE::AddModule::lets_with_shadowing --args 5u64


//# run 0xCAFE::CallerModule::call_inline_add --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_add_and_return_fixed --args 11u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d86183d03ea910e2ca6c118b6e9b2411: Test that let-bindings of u64 values can be reassigned and shadowed without errors in a Move function.
