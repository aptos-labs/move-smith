
//# publish
module 0xCAFE::TestAddition {
    // Test addition of two u8 values and return a specific value or error.
    use std::error;

    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // If sum is greater than 100, abort with code 1000
        assert!(sum <= 100, 1000);
        sum
    }

    public fun test_unexpected_token_error() {
        // Abort with an error code used to simulate unexpected token found in parsing
        abort error::invalid_argument(42);
    }

    public fun apply_unary_ops(x: u8): u8 {
        // Unary - is not supported on unsigned numbers, so test unary not operator ~
        // Instead test unary ops with combination of ! (logical not for bool)
        let flag = x > 0;
        let result: bool = !flag;
        if (result) {
            0
        } else {
            x
        }
    }
}


//# publish
module 0xCAFE::TestLambda {
    // Write functions containing lambda expressions

    public fun call_lambda_add(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 is copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun call_lambda_twice(a: u8, b: u8): u8 {
        let mul_lambda: |u8, u8|u8 is copy+drop = |x: u8, y: u8| {
            x * y
        };
        // Compose addition and multiplication
        let sum = call_lambda_add(a, b);
        let prod = mul_lambda(a, b);
        sum + prod
    }
}


//# publish
module 0xCAFE::TestInlineCalls {
    use 0xCAFE::TestLambda;

    public inline fun inline_double(x: u8): u8 {
        x * 2
    }

    public fun indirect_inline_call(x: u8, y: u8): u8 {
        // Call a lambda function from TestLambda module
        let sum = TestLambda::call_lambda_add(x, y);
        // Call the inline function
        let doubled = inline_double(sum);
        doubled
    }

    public fun cast_and_test_expr(x: u8): u16 {
        let doubled_u8 = inline_double(x);
        // Cast to u16
        let casted = (doubled_u8 as u16);
        // Test conditional expression
        if (casted > 20u16) {
            100u16
        } else {
            casted
        }
    }
}


//# run 0xCAFE::TestAddition::add_and_return --args 50u8 20u8


//# run 0xCAFE::TestAddition::add_and_return --args 60u8 50u8


//# run 0xCAFE::TestAddition::test_unexpected_token_error


//# run 0xCAFE::TestAddition::apply_unary_ops --args 0u8


//# run 0xCAFE::TestAddition::apply_unary_ops --args 1u8


//# run 0xCAFE::TestLambda::call_lambda_add --args 5u8 10u8


//# run 0xCAFE::TestLambda::call_lambda_twice --args 3u8 4u8


//# run 0xCAFE::TestInlineCalls::indirect_inline_call --args 7u8 8u8


//# run 0xCAFE::TestInlineCalls::cast_and_test_expr --args 6u8


//# run 0xCAFE::TestInlineCalls::cast_and_test_expr --args 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// d05c007f1c93df9d5a175e4c5e439e9a: Use type cast and test expressions when supported.
// 942fa01aa1f8670c2b216ffa6de0b1da: Use this function to generate an error message when an unexpected token is encountered during parsing.
// a12be701b4cca6f3c13773c6fbb4b0df: Apply unary operators to expressions with the `unary_exp` expression.
