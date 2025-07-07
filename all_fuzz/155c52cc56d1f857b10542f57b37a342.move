
//# publish
module 0xCAFE::AdditionModule {
    // Simple function that adds two u8 numbers then returns 42u8
    public fun add_and_return_42(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // just to show sum is used
        42u8
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_42 --args 10u8 20u8


//# publish
module 0xCAFE::LambdaModule {
    // Function that demonstrates lambda usage: applies a lambda twice to a u8 input
    public fun apply_twice(x: u8): u8 {
        let double_fn: |u8|u8 has copy+drop = |y: u8| {
            y * 2
        };
        let first = double_fn(x);
        let second = double_fn(first);
        second
    }

    // Function that returns a lambda function which adds 5 to input
    public fun get_adder(): |u8|u8 has copy+drop {
        let add_five: |u8|u8 has copy+drop = |z: u8| {
            z + 5
        };
        add_five
    }
}


//# run 0xCAFE::LambdaModule::apply_twice --args 3u8


//# run 0xCAFE::LambdaModule::get_adder



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    // Inline function that calls AdditionModule::add_and_return_42 indirectly
    public inline fun nested_call(a: u8, b: u8): u8 {
        let intermediate = AdditionModule::add_and_return_42(a, b);
        // Use the result plus 1 to test chaining
        intermediate + 1u8
    }

    // Public function that calls the inline nested_call and returns the result
    public fun call_nested(a: u8, b: u8): u8 {
        nested_call(a, b)
    }
}


//# run 0xCAFE::NestedCallModule::call_nested --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
