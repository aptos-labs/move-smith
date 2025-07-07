
//# publish
module 0xCAFE::Calc {
    // This module provides addition for two u8 values and a runner function that uses a lambda.

    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value after computing sum (to test correct computation and side effect).
        42u8
    }

    public fun lambda_identity_runner(): u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a
        };
        lambda(100u8)
    }

    public fun lambda_adder_runner(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}


//# run 0xCAFE::Calc::add_and_return_fixed --args 10u8 32u8


//# run 0xCAFE::Calc::lambda_identity_runner


//# run 0xCAFE::Calc::lambda_adder_runner --args 15u8 27u8


//# publish
module 0xCAFE::UseCalc {
    use 0xCAFE::Calc;

    // The function calls Calc::lambda_adder_runner and then calls Calc::add_and_return_fixed,
    // effectively testing nested function calls between modules.
    public fun nested_calls_runner(x: u8, y: u8): u8 {
        let sum = Calc::lambda_adder_runner(x, y);
        let _fixed = Calc::add_and_return_fixed(sum, 0u8);
        sum
    }
}


//# run 0xCAFE::UseCalc::nested_calls_runner --args 20u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
