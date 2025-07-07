
//# publish
module 0xCAFE::MathModule {
    // Module to test addition and lambda expressions

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value regardless of input
        42u8
    }

    public fun lambda_addition(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_addition(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::MathModule;

    public fun call_inline_addition(a: u8, b: u8): u8 {
        MathModule::inline_addition(a, b)
    }

    public fun call_lambda_addition_and_add_fixed(a: u8, b: u8): u8 {
        let lambda_sum = MathModule::lambda_addition(a, b);
        let fixed_value = MathModule::add_two_values(a, b);
        // Return sum of lambda sum and fixed_value (which is always 42)
        lambda_sum + fixed_value
    }
}


//# run 0xCAFE::MathModule::add_two_values --args 3u8 4u8


//# run 0xCAFE::MathModule::lambda_addition --args 5u8 6u8


//# run 0xCAFE::NestedCallModule::call_inline_addition --args 7u8 8u8


//# run 0xCAFE::NestedCallModule::call_lambda_addition_and_add_fixed --args 2u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
