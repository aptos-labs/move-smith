
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_example(x: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, 10u8)
    }
}


//# publish
module 0xBEEF::UseAddModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let sum = AddModule::add_and_return_sum(a, b);
        let lambda_result = AddModule::lambda_example(sum);
        lambda_result
    }
}


//# run 0xCAFE::AddModule::add_and_return_sum --args 7u8 8u8


//# run 0xCAFE::AddModule::lambda_example --args 5u8


//# run 0xBEEF::UseAddModule::call_inline_and_add --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
