
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_values_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        sum
    }

    public fun use_lambda_to_add(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }

    public fun runner() {
        let _ = add_two_values_and_return_sum(5u8, 10u8);
        let _ = use_lambda_to_add(7u8, 8u8);
    }
}


//# run 0xCAFE::AdditionModule::runner


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::AdditionModule;

    public fun nested_inline_calls(x: u8, y: u8): u8 {
        let first = AdditionModule::inline_addition(x, y);
        let second = AdditionModule::inline_addition(first, 5u8);
        second
    }

    public fun run() {
        let _ = nested_inline_calls(3u8, 4u8);
    }
}


//# run 0xCAFE::InlineCaller::run


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
