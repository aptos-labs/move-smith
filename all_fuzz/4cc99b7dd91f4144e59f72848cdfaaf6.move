
//# publish
module 0xCAFE::AdditionModule {
    const CONST_VAL: u8 = 42;

    public fun add_two_u8_and_return_value(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value plus the sum to test addition and return
        CONST_VAL + sum
    }

    public fun contains_lambda(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 10
        };
        lambda(x)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let partial = AdditionModule::inline_addition(a, b);
        // Add a fixed number to test nested call + arithmetic
        partial + 5
    }
}


//# run 0xCAFE::AdditionModule::add_two_u8_and_return_value --args 3u8 4u8


//# run 0xCAFE::AdditionModule::contains_lambda --args 5u8


//# run 0xCAFE::NestedCallModule::call_inline_and_add --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9a746c69b3deda200132aaa80170a57f: Specify return types for functions
// a24643ce43c52f9a4f043a17c778848a: Constant declarations cannot use visibility modifiers; all constants are always internal to the module.
