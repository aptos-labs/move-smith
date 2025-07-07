
//# publish
module 0xCAFE::AddModule {
    // Live variables at module start: {}

    public fun add_u8_and_return_specific_value(a: u8, b: u8): u8 {
        // Live variables at start of function: {a, b}
        let sum = a + b;
        // Live variables: {a, b, sum}
        42u8
    }

    public fun use_lambda(a: u8, b: u8): u8 {
        // Live variables: {a, b}
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            // Live variables within lambda: {x, y}
            x + y
        };
        // Live variables: {a, b, adder}
        let result = adder(a, b);
        // Live variables: {a, b, adder, result}
        result
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        // Live variables: {x, y}
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_add(x: u8, y: u8): u8 {
        // Live variables: {x, y}
        AddModule::inline_add(x, y)
    }

    public fun call_lambda_in_add_module(a: u8, b: u8): u8 {
        // Live variables: {a, b}
        AddModule::use_lambda(a, b)
    }
}


//# run 0xCAFE::AddModule::add_u8_and_return_specific_value --args 5u8 6u8


//# run 0xCAFE::AddModule::use_lambda --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_inline_add --args 9u8 10u8


//# run 0xCAFE::CallerModule::call_lambda_in_add_module --args 11u8 12u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// efbd2a6d2d9bccdd55ceb521eb042d09: Annotate each code position with the set of live variables at that point in the execution.
// 509b20779ecabeff191eebe7cae1cfbd: Declare public functions and modules using the 'public' visibility modifier.
