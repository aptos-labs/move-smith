
//# publish
module 0xCAFE::AddModule {
    // A simple function that adds two u8 numbers and returns result + 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun f_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y + 5
        };
        lambda(a, b)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AddModule::add_and_offset --args 5u8 7u8


//# run 0xCAFE::AddModule::f_with_lambda --args 3u8 4u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun test_nested_inline(a: u8, b: u8): u8 {
        let result = AddModule::inline_addition(a, b);
        // Add 10 to the result
        result + 10
    }
}


//# run 0xCAFE::CallerModule::test_nested_inline --args 8u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
