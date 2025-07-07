
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value for test purpose regardless of sum
        42u8
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun call_inline_adder(x: u8, y: u8): u8 {
        AddModule::inline_adder(x, y)
    }

    public fun nested_call_example(x: u8, y: u8): u8 {
        let res = call_inline_adder(x, y);
        AddModule::add_and_return_fixed(res, 10u8) // should always return 42
    }
}


//# run 0xCAFE::AddModule::add_and_return_fixed --args 5u8 7u8


//# run 0xCAFE::AddModule::lambda_example --args 3u8 4u8


//# run 0xCAFE::NestedCallModule::call_inline_adder --args 1u8 2u8


//# run 0xCAFE::NestedCallModule::nested_call_example --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
