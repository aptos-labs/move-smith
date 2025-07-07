
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value 42u8 after computing sum to test computation
        let _unused = sum;
        42u8
    }

    public fun lambda_test(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |y: u8| {
            y + 1u8
        };
        lambda(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 10u8


//# run 0xCAFE::AddModule::lambda_test --args 41u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        let result = AddModule::inline_add(a, b);
        // Return result + 1 to test nested call and further computation
        result + 1u8
    }

    public fun call_lambda_test(x: u8): u8 {
        AddModule::lambda_test(x)
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_add --args 10u8 20u8


//# run 0xCAFE::NestedCallModule::call_lambda_test --args 41u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
