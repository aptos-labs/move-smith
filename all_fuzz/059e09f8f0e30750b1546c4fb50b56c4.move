
//# publish
module 0xCAFE::AddModule {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            10
        } else {
            sum
        };
        sum
    }

    public fun lambda_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| a + b;
        add_lambda(x, y)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 4u8


//# run 0xCAFE::AddModule::add_two_values --args 8u8 5u8


//# run 0xCAFE::AddModule::lambda_add --args 6u8 7u8


//# publish
module 0xCAFE::NestedModule {
    use 0xCAFE::AddModule;

    public fun test_nested_call(x: u8, y: u8): u8 {
        let partial = AddModule::inline_adder(x, y);
        AddModule::add_two_values(partial, 2u8)
    }
}


//# run 0xCAFE::NestedModule::test_nested_call --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
