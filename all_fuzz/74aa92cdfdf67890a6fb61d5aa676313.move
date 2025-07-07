
//# publish
module 0xCAFE::MathModule {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let c = a + b;
        // Return a fixed value after the addition computation, e.g., 42
        42
    }

    public fun apply_lambda_to_u8(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        lambda(x)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }

    public fun call_inline_increment_indirectly(a: u8): u8 {
        // Call the inline function inline_increment from this module
        inline_increment(a)
    }
}


//# run 0xCAFE::MathModule::add_two_u8 --args 10u8 15u8


//# run 0xCAFE::MathModule::apply_lambda_to_u8 --args 21u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun nested_calls(a: u8, b: u8): u8 {
        let sum = MathModule::add_two_u8(a, b);
        let incr = MathModule::call_inline_increment_indirectly(sum);
        incr
    }

    public fun lambda_return_test(x: u8): u8 {
        let lam: |u8|u8 has copy+drop = |v: u8| {
            v + 5
        };
        lam(x)
    }
}


//# run 0xCAFE::CallerModule::nested_calls --args 10u8 20u8


//# run 0xCAFE::CallerModule::lambda_return_test --args 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
