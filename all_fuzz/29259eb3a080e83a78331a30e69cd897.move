
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun with_nested_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let inner_lambda: |u8| u8 has copy+drop = |c: u8| {
                c + 1u8
            };
            let sum = a + b;
            inner_lambda(sum)
        };
        add_lambda(x, y)
    }
}


//# run 0xCAFE::AddModule::add_and_return --args 5u8 6u8


//# run 0xCAFE::AddModule::add_and_return --args 2u8 3u8


//# run 0xCAFE::AddModule::with_lambda --args 7u8 8u8


//# run 0xCAFE::AddModule::with_nested_lambda --args 1u8 2u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_functions(x: u8, y: u8): u8 {
        let added = AddModule::add_and_return(x, y);
        let lambda_result = AddModule::with_lambda(x, y);
        let nested_lambda_result = AddModule::with_nested_lambda(x, y);
        // Return sum of all three results
        added + lambda_result + nested_lambda_result
    }
}


//# run 0xCAFE::CallerModule::call_inline_functions --args 3u8 4u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
