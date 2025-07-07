
//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42 regardless of sum
        42
    }

    public fun test_lambda_operations(): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(10u8, 32u8)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::AddModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let result = AddModule::inline_add(a, b);
        // Call another inline function AddModule::inline_add with fixed args
        let extra = AddModule::inline_add(1u8, 2u8);
        result + extra
    }

    public fun call_lambda_from_other_module(): u8 {
        let add_result = AddModule::inline_add(5u8, 6u8);
        add_result
    }
}


//# run 0xCAFE::AddModule::add_then_return_fixed --args 10u8 15u8


//# run 0xCAFE::AddModule::test_lambda_operations


//# run 0xCAFE::NestedCall::call_inline_and_add --args 10u8 20u8


//# run 0xCAFE::NestedCall::call_lambda_from_other_module


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
