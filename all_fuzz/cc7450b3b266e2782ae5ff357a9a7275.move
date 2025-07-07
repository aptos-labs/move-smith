
//# publish
module 0xCAFE::NestedCall {
    // Module to test inline function, lambda, and addition

    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_u8_and_return_const(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        let fixed_result = 42u8;
        // ignore sum, return fixed constant to test addition happened internally
        fixed_result
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        // Define a lambda that adds two values and adds 1 to the result
        let add_and_increment: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            let s = x + y;
            s + 1
        };
        add_and_increment(a, b)
    }

    public fun caller_of_inline(): u8 {
        let val = add_u8(10u8, 20u8);
        val
    }
}


//# run 0xCAFE::NestedCall::add_u8_and_return_const --args 5u8 10u8


//# run 0xCAFE::NestedCall::with_lambda --args 7u8 8u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::NestedCall;

    public fun call_nested_add(a: u8, b: u8): u8 {
        let result = NestedCall::add_u8(a, b);
        result
    }

    public fun call_nested_lambda(a: u8, b: u8): u8 {
        NestedCall::with_lambda(a, b)
    }

    public fun call_nested_inline(): u8 {
        NestedCall::caller_of_inline()
    }
}


//# run 0xCAFE::CallerModule::call_nested_add --args 15u8 20u8


//# run 0xCAFE::CallerModule::call_nested_lambda --args 3u8 4u8


//# run 0xCAFE::CallerModule::call_nested_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
