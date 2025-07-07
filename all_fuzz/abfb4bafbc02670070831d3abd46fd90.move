
//# publish
module 0xCAFE::LambdaTest {
    // This module tests lambda expressions usage and inline function calls within lambdas
    use std::vector;

    public inline fun multiply_add(a: u8, b: u8, c: u8): u8 {
        a * b + c
    }

    public fun lambda_usage(x: u8, y: u8, z: u8): u8 {
        // Lambda takes (u8, u8) and returns u8 by calling inline multiply_add from same module
        let op: |u8, u8|u8 = |a: u8, b: u8| {
            multiply_add(a, b, 10u8)
        };
        let res = op(x, y) + z;
        res
    }

    public fun tuple_pattern_assignment(): (u8, u8, u8) {
        // Use pattern matching to assign local variables
        let (a, b, c) = (1u8, 2u8, 3u8);
        (a, b, c)
    }
}


//# run 0xCAFE::LambdaTest::lambda_usage --args 2u8 3u8 4u8


//# run 0xCAFE::LambdaTest::tuple_pattern_assignment



//# publish
module 0xCAFE::LambdaCaller {
    use 0xCAFE::LambdaTest;

    // Calls lambda_usage from LambdaTest implicitly showing nested cross-module inline function call
    public fun call_lambda_usage(x: u8, y: u8, z: u8): u8 {
        LambdaTest::lambda_usage(x, y, z)
    }

    public fun assign_pattern_example(): u8 {
        let (a, b, c) = (10u8, 20u8, 30u8);
        a + b + c
    }
}


//# run 0xCAFE::LambdaCaller::call_lambda_usage --args 5u8 6u8 7u8


//# run 0xCAFE::LambdaCaller::assign_pattern_example


// Featurres:
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// f88406655feb90bcc45b9908e95b74a2: Declare and use local variables in patterns on the left-hand side of assignments.
