
//# publish
module 0xCAFE::AdditionModule {
    // A simple function that adds two u8 and returns u8 result increased by 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun add_inline(a: u8, b: u8): u8 {
        // Inline anonymous lambda that adds two u8 values
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }
}


//# run 0xCAFE::AdditionModule::add_and_offset --args 5u8 7u8


//# run 0xCAFE::AdditionModule::add_inline --args 8u8 12u8


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AdditionModule;

    public fun call_add_and_offset(a: u8, b: u8): u8 {
        let result = AdditionModule::add_and_offset(a, b);
        result
    }

    public fun call_add_inline_with_offset(a: u8, b: u8): u8 {
        let inline_result = AdditionModule::add_inline(a, b);
        let final_result = inline_result + 5;
        final_result
    }
}


//# run 0xCAFE::NestedCalls::call_add_and_offset --args 10u8 15u8


//# run 0xCAFE::NestedCalls::call_add_inline_with_offset --args 20u8 25u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
