
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
        let add_lambda = |x: u8, y: u8| {
            x + y
        };
        add_lambda(a, b)
    }

    public fun call_lambda_twice(a: u8, b: u8): u8 {
        let mul_lambda = |x: u8, y: u8| {
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
