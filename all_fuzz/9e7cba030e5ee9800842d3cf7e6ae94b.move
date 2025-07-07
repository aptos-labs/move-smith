
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_expression_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_adder(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AdditionModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let intermediate = AdditionModule::inline_adder(a, b);
        AdditionModule::add_and_return_sum(intermediate, 1u8)
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::AdditionModule::lambda_expression_example --args 10u8 15u8


//# run 0xCAFE::NestedInlineCaller::call_inline_and_add --args 10u8 20u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
