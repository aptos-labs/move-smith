
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_two_numbers_and_return_result(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) { 10u8 } else { sum };
        result
    }

    public fun lambda_example(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |v: u8| v * 2;
        doubler(x)
    }
}


//# run 0xCAFE::AddAndLambda::add_two_numbers_and_return_result --args 3u8 5u8


//# run 0xCAFE::AddAndLambda::add_two_numbers_and_return_result --args 7u8 8u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 4u8


//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddAndLambda;

    public inline fun double_then_add(a: u8, b: u8): u8 {
        let doubled_a = AddAndLambda::lambda_example(a);
        let sum = AddAndLambda::add_two_numbers_and_return_result(doubled_a, b);
        sum
    }

    public fun runner(): u8 {
        double_then_add(3u8, 4u8)
    }
}


//# run 0xCAFE::CallInline::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
