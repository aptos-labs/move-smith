
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed_value(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed_value = 42u8;
        assert!(sum > 0, 0);
        fixed_value
    }

    public fun with_lambda(x: u8): u8 {
        let add_one: |u8| u8 has copy+drop = |v: u8| { v + 1u8 };
        add_one(x)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed_value --args 10u8 32u8


//# run 0xCAFE::AdditionModule::with_lambda --args 41u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun nested_call(a: u8, b: u8): u8 {
        let inline_sum = AdditionModule::inline_adder(a, b);
        AdditionModule::add_and_return_fixed_value(inline_sum, 1u8)
    }
}


//# run 0xCAFE::NestedCallModule::nested_call --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
