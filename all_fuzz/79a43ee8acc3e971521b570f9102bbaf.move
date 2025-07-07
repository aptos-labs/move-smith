
//# publish
module 0xCAFE::LambdaModule {
    // Module to test lambda functions and addition computations

    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;

        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };

        let lambda_sum = lambda(x, y);
        // Return sum + lambda_sum (which is (x+y) + (x+y))
        sum + lambda_sum
    }

    public inline fun add_one(a: u8): u8 {
        a + 1
    }

    public fun call_inline_add_one_twice(x: u8): u8 {
        let first_call = add_one(x);
        add_one(first_call)
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;

    public fun call_lambda_add_and_return_sum(x: u8, y: u8): u8 {
        0xCAFE::LambdaModule::add_and_return_sum(x, y)
    }

    public fun nested_inline_calls(x: u8): u8 {
        0xCAFE::LambdaModule::call_inline_add_one_twice(x)
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::LambdaModule::call_inline_add_one_twice --args 10u8


//# run 0xCAFE::NestedCallModule::call_lambda_add_and_return_sum --args 3u8 4u8


//# run 0xCAFE::NestedCallModule::nested_inline_calls --args 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
