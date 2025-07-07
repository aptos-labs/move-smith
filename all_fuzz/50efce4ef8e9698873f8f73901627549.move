
//# publish
module 0xCAFE::AddModule {
    public fun add_two_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_example(x: u8): u8 {
        let increment: |u8|u8 has copy+drop = |y: u8| {
            y + 1
        };
        increment(x)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun runner_inline(): u8 {
        inline_add(10, 15)
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AddModule;

    public fun call_inline_and_lambda(x: u8, y: u8): (u8, u8) {
        let inline_sum = AddModule::inline_add(x, y);
        let lambda_result = AddModule::lambda_example(inline_sum);
        (inline_sum, lambda_result)
    }

    public fun runner(): (u8, u8) {
        call_inline_and_lambda(5, 7)
    }
}


//# run 0xCAFE::AddModule::add_two_and_return_sum --args 3u8 4u8


//# run 0xCAFE::AddModule::lambda_example --args 9u8


//# run 0xCAFE::AddModule::runner_inline


//# run 0xCAFE::NestedCallModule::call_inline_and_lambda --args 8u8 12u8


//# run 0xCAFE::NestedCallModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
