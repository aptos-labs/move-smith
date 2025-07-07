
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed value 42u8 regardless of sum
        42u8
    }

    public fun use_lambda_and_apply(x: u8, y: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = lambda(x, y);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_fixed --args 10u8 20u8


//# run 0xCAFE::AdditionModule::use_lambda_and_apply --args 5u8 7u8


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_and_lambda(x: u8, y: u8): (u8, u8) {
        let sum_inline = AdditionModule::inline_add(x, y);
        let sum_lambda = {
            let lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
                AdditionModule::inline_add(a, b)
            };
            lambda(x, y)
        };
        (sum_inline, sum_lambda)
    }

    public fun runner() {
        let (_a, _b) = call_inline_and_lambda(15u8, 27u8);
        // no assert required, just run
    }
}


//# run 0xCAFE::NestedCallModule::call_inline_and_lambda --args 12u8 13u8


//# run 0xCAFE::NestedCallModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
