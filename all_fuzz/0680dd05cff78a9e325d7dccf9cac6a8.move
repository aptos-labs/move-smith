
//# publish
module 0xCAFE::MathUtils {
    public inline fun add_u8(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return_sum(a: u8, b: u8): u8 {
        let sum = add_u8(a, b);
        // returns sum + 1 to differentiate from plain add
        sum + 1
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = adder(a, b);
        result
    }
}


//# run 0xCAFE::MathUtils::compute_and_return_sum --args 3u8 4u8


//# run 0xCAFE::MathUtils::with_lambda --args 7u8 9u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathUtils;

    public fun call_inline_addition(x: u8, y: u8): u8 {
        // call inline function from MathUtils to add, then add 2 more
        let s = MathUtils::add_u8(x, y);
        s + 2
    }

    public fun call_lambda_function(x: u8, y: u8): u8 {
        MathUtils::with_lambda(x, y)
    }

    public fun runner() {
        let _ = call_inline_addition(5u8, 6u8);
        let _ = call_lambda_function(8u8, 3u8);
    }
}


//# run 0xCAFE::CallerModule::call_inline_addition --args 1u8 2u8


//# run 0xCAFE::CallerModule::call_lambda_function --args 10u8 20u8


//# run 0xCAFE::CallerModule::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
