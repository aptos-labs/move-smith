
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        // return the sum plus an offset constant 10u8
        sum + 10u8
    }
}


//# run 0xCAFE::TestAddition::add_and_return_constant --args 5u8 6u8


//# publish
module 0xCAFE::LambdaTests {
    public fun test_lambda_addition(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = lambda(a, b);
        sum
    }

    public fun test_lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let diff = if (x > y) {x - y} else {y - x};
            (sum, diff)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::LambdaTests::test_lambda_addition --args 10u8 15u8


//# run 0xCAFE::LambdaTests::test_lambda_return_tuple --args 10u8 15u8


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::TestAddition;

    public inline fun multiply(a: u8, b: u8): u8 {
        a * b
    }

    public fun call_test_addition_twice(a: u8, b: u8): u8 {
        let first_call = TestAddition::add_and_return_constant(a, b);
        // call multiply with the two results
        let second_call = multiply(first_call, 2u8);
        second_call
    }
}


//# run 0xCAFE::InlineCaller::call_test_addition_twice --args 1u8 2u8


//# publish
module 0xCAFE::FunctionExpressionCaller {
    use 0xCAFE::LambdaTests;

    public fun call_lambda_directly(a: u8, b: u8): u8 {
        // anonymous function expression passed and invoked immediately
        (|x: u8, y: u8| x * y)(a, b)
    }

    public fun call_lambda_from_module(a: u8, b: u8): (u8, u8) {
        // call LambdaTests::test_lambda_return_tuple directly with function expression wrapper
        LambdaTests::test_lambda_return_tuple(a, b)
    }
}


//# run 0xCAFE::FunctionExpressionCaller::call_lambda_directly --args 3u8 7u8


//# run 0xCAFE::FunctionExpressionCaller::call_lambda_from_module --args 3u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// de5d1ef455050329b653e3f4db5966aa: Create expressions calling functions directly with function expressions and argument list.
