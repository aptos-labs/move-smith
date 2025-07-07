
//# publish
module 0xCAFE::TestLambda {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;

        let lambda: |u8|u8 has copy+drop = |a: u8| {
            a * 2
        };

        let doubled_sum = lambda(sum);
        // return doubled_sum - 1 will return a value dependent on sum
        doubled_sum - 1
    }

    public fun return_lambda_value() {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _result = lambda(10u8, 15u8);
    }
}


//# run 0xCAFE::TestLambda::add_and_return --args 3u8 4u8


//# run 0xCAFE::TestLambda::return_lambda_value


//# publish
module 0xCAFE::TestInlineCall {
    use 0xCAFE::TestLambda;

    public inline fun inline_sum_double(a: u8, b: u8): u8 {
        let addition = a + b;
        let doubled = TestLambda::add_and_return(addition, 0u8);
        doubled
    }

    public fun runner(): u8 {
        let result = inline_sum_double(5u8, 6u8);
        result
    }
}


//# run 0xCAFE::TestInlineCall::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
