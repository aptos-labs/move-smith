
//# publish
module 0xCAFE::AddAndLambda {
    // Test addition of two u8 values and lambda expressions

    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;

        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a + 1
        };
        let incremented = lambda(sum);

        // return sum + 10 to differentiate from lambda result
        sum + 10
    }

    public fun call_lambda_increment(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a + 5
        };
        lambda(x)
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }
}


//# run 0xCAFE::AddAndLambda::add_two_values --args 4u8 5u8


//# run 0xCAFE::AddAndLambda::call_lambda_increment --args 9u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndLambda;

    public fun call_inline_increment_from_other_module(x: u8): u8 {
        AddAndLambda::inline_increment(x)
    }

    public fun nested_call_using_lambda(x: u8, y: u8): u8 {
        let add_result = AddAndLambda::add_two_values(x, y);
        let lambda: |u8| u8 has copy+drop = |a: u8| {
            a * 2
        };
        lambda(add_result)
    }

    public fun runner() {
        let _ = call_inline_increment_from_other_module(10u8);
        let _ = nested_call_using_lambda(3u8, 7u8);
    }
}


//# run 0xCAFE::CallerModule::call_inline_increment_from_other_module --args 20u8


//# run 0xCAFE::CallerModule::nested_call_using_lambda --args 2u8 3u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
