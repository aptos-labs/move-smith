
//# publish
module 0xCAFE::AddModule {
    // Module tests addition of u8 values and lambdas

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = if (sum > 10) {
            1
        } else {
            0
        };
        42u8
    }

    public fun use_lambda_and_return(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let res = lambda(x, y);
        // return lambda result plus 1
        res + 1
    }
}


//# run 0xCAFE::AddModule::add_two_values --args 5u8 7u8


//# run 0xCAFE::AddModule::use_lambda_and_return --args 6u8 9u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun nested_call(x: u8, y: u8): u8 {
        let result = AddModule::use_lambda_and_return(x, y);
        // Adding 5 to result of the call
        result + 5
    }
}


//# run 0xCAFE::CallerModule::nested_call --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
