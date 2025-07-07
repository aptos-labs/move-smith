
//# publish
module 0xCAFE::Calculator {
    use std::vector;

    public fun add_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 100) {
            255u8
        } else {
            sum
        }
    }

    public fun apply_lambda_on_values(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::CalculatorUser {
    use 0xCAFE::Calculator::{add_u8_values, inline_add};

    public fun sum_and_limit(a: u8, b: u8): u8 {
        let sum = add_u8_values(a, b);
        if (sum > 50) {
            50u8
        } else {
            sum
        }
    }

    public fun nested_inline_calls(x: u8, y: u8): u8 {
        let first = inline_add(x, y);
        let second = inline_add(first, y);
        second
    }
}


//# run 0xCAFE::Calculator::add_u8_values --args 60u8 30u8


//# run 0xCAFE::Calculator::apply_lambda_on_values --args 7u8 8u8


//# run 0xCAFE::CalculatorUser::sum_and_limit --args 25u8 30u8


//# run 0xCAFE::CalculatorUser::nested_inline_calls --args 10u8 15u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 856cee270806f36c7f5a492dd5982c36: Import specific members from modules using the 'use' statement
