
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add = |a: u8, b: u8| { a + b };
        add(x, y)
    }

    public inline fun inline_adder(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let sum = AddModule::inline_adder(x, y);
        let lambda_result = AddModule::lambda_example(x, y);
        sum + lambda_result
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::AddModule::lambda_example --args 10u8 20u8


//# run 0xCAFE::CallerModule::call_inline_and_lambda --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
