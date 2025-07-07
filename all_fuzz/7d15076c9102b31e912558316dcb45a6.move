
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;

        // Return sum + 1 to verify calculation after addition
        sum + 1
    }

    public fun apply_lambda_on_values(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x + y };
        let result = add_lambda(a, b);

        let multiply_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| { x * y };
        let product = multiply_lambda(a, b);

        // Return sum of add_lambda result and multiply_lambda result to test lambdas
        result + product
    }
}


//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public inline fun inline_double_add(a: u8, b: u8): u8 {
        AdditionModule::add_and_return_sum(a, b) + AdditionModule::add_and_return_sum(b, a)
    }

    public fun nested_call(a: u8, b: u8): u8 {
        let first = inline_double_add(a, b);
        let second = AdditionModule::apply_lambda_on_values(a, b);

        first + second
    }
}


//# publish
module 0xCAFE::IfExpressionModule {
    // lint_skip(variable_shadowing)]
    public fun complex_if_expression(x: u8, y: u8): u8 {
        let result = if (x > y) {
            if (y == 0) {
                x + 5
            } else {
                x + y * 2
            }
        } else {
            if (y > 10) {
                y - x
            } else {
                y + x / 2
            }
        };

        result
    }

    // lint_skip(dead_code)]
    public fun ignored_function() {
        let x = 42;
        let _unused = x + 1;
    }
}


//# run 0xCAFE::AdditionModule::add_and_return_sum --args 5u8 10u8


//# run 0xCAFE::AdditionModule::apply_lambda_on_values --args 3u8 4u8


//# run 0xCAFE::NestedCallModule::nested_call --args 2u8 3u8


//# run 0xCAFE::IfExpressionModule::complex_if_expression --args 7u8 0u8


//# run 0xCAFE::IfExpressionModule::complex_if_expression --args 5u8 11u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 5c088a9760fee25ce0fe5d966fd0608e: Test that the Move language correctly parses and evaluates if-expressions within complex expressions and operator precedence contexts.
// 3c50d21bbb4567ffaa575f96d84c2c36: Use attribute-based lint skip annotations on Move functions to suppress specific lints.
