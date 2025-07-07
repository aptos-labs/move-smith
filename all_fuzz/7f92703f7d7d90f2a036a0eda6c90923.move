
//# publish
module 0xCAFE::MathModule {
    // A module for arithmetic and lambdas

    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum + 5u8;
        7u8
    }

    public fun lambda_example(): u8 {
        let add: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = add(10u8, 20u8);
        result
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_inline_and_lambda(): u8 {
        let sum = MathModule::inline_add(15u8, 25u8);
        let lambda_result = MathModule::lambda_example();
        sum + lambda_result
    }

    public fun call_add_two_values(a: u8, b: u8): u8 {
        let _ = MathModule::add_two_values(a, b);
        42u8
    }
}


//# run 0xCAFE::MathModule::add_two_values --args 12u8 34u8


//# run 0xCAFE::MathModule::lambda_example


//# run 0xCAFE::CallerModule::call_inline_and_lambda


//# run 0xCAFE::CallerModule::call_add_two_values --args 1u8 2u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
