
//# publish
module 0xCAFE::AddModule {
    // This module tests addition of two u8 values with constants and lambdas

    const ADD_CONSTANT: u8 = 10;

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Add a constant value before returning
        sum + ADD_CONSTANT
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = add_lambda(a, b);
        sum + ADD_CONSTANT
    }

    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_module(a: u8, b: u8): u8 {
        AddModule::add_two_values(a, b)
    }

    public fun call_add_with_lambda(a: u8, b: u8): u8 {
        AddModule::add_with_lambda(a, b)
    }

    public fun call_inline_add(a: u16, b: u16): u16 {
        // nested call to inline function from AddModule
        AddModule::inline_add(a, b)
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 7u8


//# run 0xCAFE::AddModule::add_with_lambda --args 8u8 9u8


//# run 0xCAFE::CallerModule::call_add_module --args 2u8 3u8


//# run 0xCAFE::CallerModule::call_add_with_lambda --args 4u8 6u8


//# run 0xCAFE::CallerModule::call_inline_add --args 100u16 150u16


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f7e53e05fded97e1b2de448aadd6fab2: Declare constant values for use within modules.
// f4d7f8ca94166c96bec2005e0e98ffa4: Constant declarations cannot be marked with the 'entry' modifier; this is only for functions.
