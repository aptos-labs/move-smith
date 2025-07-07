
//# publish
module 0xCAFE::MathWithLambda {
    public inline fun add(a: u8, b: u8): u8 {
        a + b
    }

    public fun compute_and_return_sum_plus_ten(a: u8, b: u8): u8 {
        let sum = add(a, b);
        sum + 10
    }

    public fun lambda_adder(): |u8, u8| u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda
    }
}


//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::MathWithLambda;

    public fun call_inline_and_lambda(a: u8, b: u8): (u8, u8) {
        let sum_plus_ten = MathWithLambda::compute_and_return_sum_plus_ten(a, b);
        let lambda = MathWithLambda::lambda_adder();
        let lambda_sum = lambda(a, b);
        (sum_plus_ten, lambda_sum)
    }

    public fun runner() {
        let (spt, ls) = call_inline_and_lambda(5u8, 7u8);
        // intentionally unused variables; gains coverage of the call
        let _ = spt;
        let _ = ls;
    }
}


//# run 0xCAFE::MathWithLambda::compute_and_return_sum_plus_ten --args 10u8 15u8


//# run 0xCAFE::MathWithLambda::lambda_adder


//# run 0xCAFE::NestedCalls::call_inline_and_lambda --args 20u8 22u8


//# run 0xCAFE::NestedCalls::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
