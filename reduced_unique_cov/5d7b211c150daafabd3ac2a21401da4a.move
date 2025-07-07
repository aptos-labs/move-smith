
//# publish
module 0xCAFE::MathUtil {
    const MAGIC_NUMBER: u8 = 42;

    public fun add_two_values(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_and_check(x: u8, y: u8): u8 {
        let sum = add_two_values(x, y);
        if (sum == MAGIC_NUMBER) {
            1u8
        } else {
            0u8
        }
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8| u8 has copy + drop = |v: u8| {
            v * 2
        };
        f(x)
    }

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let lambda_func: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            add_two_values(a, b)
        };
        lambda_func(x, y)
    }
}


//# run 0xCAFE::MathUtil::add_two_values --args 10u8 32u8


//# run 0xCAFE::MathUtil::add_and_check --args 40u8 2u8


//# run 0xCAFE::MathUtil::lambda_example --args 16u8


//# run 0xCAFE::MathUtil::call_inline_and_lambda --args 8u8 9u8


//# publish
module 0xCAFE::UseMathUtil {
    use 0xCAFE::MathUtil::{
        add_two_values,
        add_and_check,
        lambda_example,
        call_inline_and_lambda,
        MAGIC_NUMBER,
    };

    struct ResultHolder has copy, drop {
        value: u8,
    }

    public fun nested_calls_return_value(x: u8, y: u8): u8 {
        let sum = add_two_values(x, y);
        let checked = add_and_check(sum, 0u8);
        checked
    }

    public fun lambda_wrapper(x: u8): u8 {
        lambda_example(x)
    }

    public fun indirect_call(x: u8, y: u8): u8 {
        call_inline_and_lambda(x, y)
    }

    // Pure function that calls other pure functions
    // spec]
    public fun add_and_double_spec(x: u8, y: u8): u8 {
        let sum = add_two_values(x, y);
        let doubled = sum * 2;
        doubled
    }
}


//# run 0xCAFE::UseMathUtil::nested_calls_return_value --args 20u8 22u8


//# run 0xCAFE::UseMathUtil::lambda_wrapper --args 21u8


//# run 0xCAFE::UseMathUtil::indirect_call --args 15u8 27u8


//# run 0xCAFE::UseMathUtil::add_and_double_spec --args 10u8 15u8


//# publish
module 0xCAFE::PureCallTest {
    use 0xCAFE::MathUtil::{
        add_two_values,
        add_and_check,
    };

    // Non-Move function call example with pure arguments to get a pure expression
    public fun pure_expression_eval(x: u8, y: u8): u8 {
        let temp = add_two_values(x, y);
        add_and_check(temp, 0u8)
    }
}


//# run 0xCAFE::PureCallTest::pure_expression_eval --args 20u8 22u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 9ef46790f73a4b2d6cabd8cc8f268480: Call Move functions from within specifications, and have them automatically converted to specification functions for use in proofs and verification.
// e0f723b44afdc4c1f59c12350179c24a: Import all public functions, structs, and constants from another module using member imports in the 'use' statement.
// bc346af183d1aeed99e5bc4417acd900: Use non-Move (i.e., non-MoveFunction) function calls with all pure arguments to produce expressions the compiler can recognize as pure.
