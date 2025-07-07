
//# publish
module 0xCAFE::AdditionModule {
    // Simple addition function that adds two u8 numbers and returns x + y + 1
    public fun add_with_increment(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 1
    }

    // Function using a lambda that adds two numbers
    public fun add_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }

    // Inline function returning tuple
    public inline fun inline_add(a: u8, b: u8): (u8, u8) {
        (a + b, a - b)
    }

    // Runner function that calls the inline function and returns the sum of the tuple's values
    public fun call_inline(a: u8, b: u8): u8 {
        let (x, y) = inline_add(a, b);
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AdditionModule;

    // Calls add_with_increment from AdditionModule and returns the result
    public fun call_add_with_increment(x: u8, y: u8): u8 {
        AdditionModule::add_with_increment(x, y)
    }

    // Calls add_lambda from AdditionModule
    public fun call_add_lambda(x: u8, y: u8): u8 {
        AdditionModule::add_lambda(x, y)
    }

    // Calls call_inline from AdditionModule to test nested inline function and normal function calls
    public fun call_call_inline(a: u8, b: u8): u8 {
        AdditionModule::call_inline(a, b)
    }
}


//# run 0xCAFE::AdditionModule::add_with_increment --args 5u8 10u8


//# run 0xCAFE::AdditionModule::add_lambda --args 7u8 9u8


//# run 0xCAFE::AdditionModule::call_inline --args 12u8 3u8


//# run 0xCAFE::CallerModule::call_add_with_increment --args 8u8 2u8


//# run 0xCAFE::CallerModule::call_add_lambda --args 4u8 6u8


//# run 0xCAFE::CallerModule::call_call_inline --args 10u8 5u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
