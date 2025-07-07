
//# publish
module 0xCAFE::LambdaTest {
    /// Adds two u8 values and returns a fixed value 42u8
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _unused = sum; // Use sum to avoid warnings. Here sum is computed.
        42u8
    }

    /// Defines a lambda that multiplies input by 2
    public fun lambda_times_two(x: u8): u8 {
        let double_lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };
        double_lambda(x)
    }

    /// Defines a lambda that sums two u8 and returns the result doubled
    public fun lambda_sum_double(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            (x + y) * 2
        };
        sum_lambda(a, b)
    }
}


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    /// Calls add_and_return_fixed in LambdaTest and returns its result
    public fun call_add_and_return_fixed(): u8 {
        LambdaTest::add_and_return_fixed(10u8, 20u8)
    }

    /// Calls lambda_times_two in LambdaTest and returns its result
    public fun call_lambda_times_two(x: u8): u8 {
        LambdaTest::lambda_times_two(x)
    }

    /// Calls lambda_sum_double in LambdaTest and returns its result
    public fun call_lambda_sum_double(a: u8, b: u8): u8 {
        LambdaTest::lambda_sum_double(a, b)
    }
}


//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 3u8 4u8


//# run 0xCAFE::LambdaTest::lambda_times_two --args 7u8


//# run 0xCAFE::LambdaTest::lambda_sum_double --args 5u8 6u8


//# run 0xCAFE::InlineCaller::call_add_and_return_fixed


//# run 0xCAFE::InlineCaller::call_lambda_times_two --args 8u8


//# run 0xCAFE::InlineCaller::call_lambda_sum_double --args 4u8 3u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 69669e6897ba3c0591e53ac0d7add7eb: Define functions as members of a module
