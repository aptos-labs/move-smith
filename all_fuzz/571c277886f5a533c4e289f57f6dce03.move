
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // returns sum + 10
        sum + 10
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(a, b);
        // returns result + 5
        result + 5
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y + 1
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_add_and_return(a: u8, b: u8): u8 {
        AddModule::add_and_return(a, b)
    }

    public fun call_lambda_function(a: u8, b: u8): u8 {
        AddModule::with_lambda(a, b)
    }

    public fun call_inline_function(a: u8, b: u8): u8 {
        // add 2 to the result from inline_adder
        let val = AddModule::inline_adder(a, b);
        val + 2
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 7u8 8u8


//# run 0xCAFE::AddModule::with_lambda --args 10u8 15u8


//# run 0xCAFE::CallerModule::call_add_and_return --args 5u8 6u8


//# run 0xCAFE::CallerModule::call_lambda_function --args 4u8 6u8


//# run 0xCAFE::CallerModule::call_inline_function --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
