
//# publish
module 0xCAFE::MathModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_lambda_example(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public fun nested_call(x: u8, y: u8): u8 {
        let sum = MathModule::inline_add(x, y);
        let final_val = MathModule::add_and_return_sum(sum, 1u8);
        final_val
    }
}


//# run 0xCAFE::MathModule::add_and_return_sum --args 10u8 20u8


//# run 0xCAFE::MathModule::call_lambda_example --args 7u8 8u8


//# run 0xCAFE::NestedCallModule::nested_call --args 5u8 6u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
