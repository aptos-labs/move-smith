
//# publish
module 0xCAFE::MathLambda {
    public inline fun add_inline(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_add_then_return(c: u8, d: u8): u8 {
        let sum = add_inline(c, d);
        // return sum + 1 for test
        sum + 1
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    public fun nested_lambda_applied(x: u8): u8 {
        let times_two: |u8| u8 has copy+drop = |a: u8| { a * 2 };
        let add_three: |u8| u8 has copy+drop = |b: u8| { b + 3 };
        let res_1 = times_two(x);
        add_three(res_1)
    }

    public fun run_all(): u8 {
        let res1 = compute_add_then_return(2u8, 3u8);
        let res2 = lambda_example(5u8, 7u8);
        let res3 = nested_lambda_applied(4u8);
        res1 + res2 + res3
    }
}


//# publish
module 0xCAFE::UseMathLambda {
    use 0xCAFE::MathLambda;

    public fun call_compute_add_then_return(a: u8, b: u8): u8 {
        MathLambda::compute_add_then_return(a, b)
    }

    public fun call_lambda_example(a: u8, b: u8): u8 {
        MathLambda::lambda_example(a, b)
    }

    public fun call_nested_lambda_applied(a: u8): u8 {
        MathLambda::nested_lambda_applied(a)
    }

    public fun call_run_all(): u8 {
        MathLambda::run_all()
    }
}


//# run 0xCAFE::MathLambda::compute_add_then_return --args 5u8 10u8


//# run 0xCAFE::MathLambda::lambda_example --args 7u8 8u8


//# run 0xCAFE::MathLambda::nested_lambda_applied --args 6u8


//# run 0xCAFE::MathLambda::run_all


//# run 0xCAFE::UseMathLambda::call_compute_add_then_return --args 3u8 4u8


//# run 0xCAFE::UseMathLambda::call_lambda_example --args 10u8 11u8


//# run 0xCAFE::UseMathLambda::call_nested_lambda_applied --args 5u8


//# run 0xCAFE::UseMathLambda::call_run_all


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
