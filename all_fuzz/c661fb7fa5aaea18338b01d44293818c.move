
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value (42) after computing sum to check computation happened
        42u8
    }

    public fun lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(2u8, 3u8)
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_add(a: u8, b: u8): u8 {
        AdditionModule::add_and_return_fixed(a, b)
    }

    public fun call_inline_and_lambda(): u8 {
        let res1 = inline_add(5u8, 6u8);
        let res2 = AdditionModule::lambda_example();
        res1 + res2
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AdditionModule::lambda_example


//# run 0xCAFE::NestedCallModule::call_inline_and_lambda


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
