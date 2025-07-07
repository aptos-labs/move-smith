
//# publish
module 0xCAFE::TestAdd {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            1u8
        };
        100u8
    }
}


//# run 0xCAFE::TestAdd::add_two_values --args 5u8 6u8


//# publish
module 0xCAFE::TestLambdas {
    public fun call_lambda_on_value(x: u8): u8 {
        let double_fn: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        double_fn(x)
    }

    public fun multi_lambda_sum(x: u8, y: u8): u8 {
        let add_fn: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {a + b};
        let mul_fn: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {a * b};
        let s = add_fn(x, y);
        let p = mul_fn(x, y);
        s + p
    }

    public fun call_lambda_return_lambda(): |u8|u8 {
        let make_incrementer = || {
            |x: u8|x + 1
        };
        make_incrementer()
    }
}


//# run 0xCAFE::TestLambdas::call_lambda_on_value --args 21u8


//# run 0xCAFE::TestLambdas::multi_lambda_sum --args 3u8 4u8


//# run 0xCAFE::TestLambdas::call_lambda_return_lambda


//# publish
module 0xCAFE::TestCallInline {
    use 0xCAFE::TestAdd;

    public inline fun inline_double(x: u8): u8 {
        let (a, b) = (x, x);
        a + b
    }

    public fun call_nested_functions(x: u8, y: u8): u8 {
        let sum = TestAdd::add_two_values(x, y);
        let doubled_sum = inline_double(sum);
        doubled_sum + 1u8
    }
}


//# run 0xCAFE::TestCallInline::call_nested_functions --args 4u8 8u8


//# publish
module 0xCAFE::TestCondition {
    public fun return_100_if_true(): u8 {
        if (true) {
            100u8
        } else {
            0u8
        }
    }
}


//# run 0xCAFE::TestCondition::return_100_if_true


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
// 4ada9cbecf52d833f672887a3d040928: Test that the function returns 100 when called, ensuring the conditional branch executes correctly.
