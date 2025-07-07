
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        // return constant 42 regardless sum for this test
        42
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_constant --args 10u8 32u8


//# run 0xCAFE::AdditionModule::with_lambda --args 20u8 22u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun nested_call(a: u8, b: u8): u8 {
        let sum = AdditionModule::inline_add(a, b);
        sum + 1
    }

    public fun call_lambda_via_runner(): u8 {
        AdditionModule::with_lambda(5u8, 7u8)
    }
}


//# run 0xCAFE::NestedCallModule::nested_call --args 15u8 25u8


//# run 0xCAFE::NestedCallModule::call_lambda_via_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
