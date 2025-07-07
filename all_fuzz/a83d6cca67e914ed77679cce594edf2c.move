
//# publish
module 0xCAFE::LambdaModule {
    // A module to test lambda functions and computations

    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42u8 regardless of inputs, to test addition internally
        42u8
    }

    public fun lambda_caller(): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        f(10u8, 20u8)
    }
}


//# run 0xCAFE::LambdaModule::add_and_return_fixed --args 5u8 10u8


//# run 0xCAFE::LambdaModule::lambda_caller



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaModule;

    public inline fun call_add_and_return_fixed(a: u8, b: u8): u8 {
        LambdaModule::add_and_return_fixed(a, b)
    }

    public fun nested_inline_call(x: u8, y: u8): u8 {
        let val = call_add_and_return_fixed(x, y);
        val
    }
}


//# run 0xCAFE::InlineCaller::nested_inline_call --args 7u8 8u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
