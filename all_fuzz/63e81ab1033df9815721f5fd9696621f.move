
//# publish
module 0xCAFE::MathWithLambda {
    use std::vector;

    /// Simple function to add two u8 values and return the sum plus 10
    public fun add_then_ten(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Function demonstrating use of a lambda (anonymous function) that multiplies two u8 and returns u8
    public fun lambda_multiply() {
        let multiply: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let _result = multiply(3u8, 4u8);
    }

    /// Function demonstrating a lambda that captures environment variable and returns u8
    public fun lambda_capture(a: u8): u8 {
        let base = 5u8;
        let add_base: |u8|u8 has copy+drop = |x: u8| {
            base + x
        };
        add_base(a)
    }
}


//# run 0xCAFE::MathWithLambda::add_then_ten --args 10u8 20u8


//# run 0xCAFE::MathWithLambda::lambda_multiply


//# run 0xCAFE::MathWithLambda::lambda_capture --args 7u8


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathWithLambda;

    /// Call a simple add_then_ten function from MathWithLambda
    public fun call_add_then_ten(a: u8, b: u8): u8 {
        MathWithLambda::add_then_ten(a, b)
    }

    /// Call lambda_capture function from MathWithLambda with no arguments through a "runner" that returns u8
    public fun call_lambda_capture_no_args(): u8 {
        MathWithLambda::lambda_capture(8u8)
    }
}


//# run 0xCAFE::CallerModule::call_add_then_ten --args 15u8 25u8


//# run 0xCAFE::CallerModule::call_lambda_capture_no_args


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
