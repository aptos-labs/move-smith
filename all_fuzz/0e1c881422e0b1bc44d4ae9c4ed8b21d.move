
//# publish
module 0xCAFE::TestAddition {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_lambda_example(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }
}


//# publish
module 0xCAFE::TestLambda {
    public fun lambda_with_capture(a: u8, b: u8): u8 {
        let c = b + 1u8;
        let lambda: |u8| u8 has copy+drop = |x: u8| { x + c };
        lambda(a)
    }

    public fun lambda_with_no_capture(a: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |x: u8| { x + 10u8 };
        lambda(a)
    }
}


//# publish
module 0xCAFE::TestNestedCall {
    use 0xCAFE::TestAddition;

    public inline fun inline_double_add(x: u8, y: u8): u8 {
        let sum = TestAddition::add_and_return_sum(x, y);
        let sum_twice = TestAddition::add_and_return_sum(sum, sum);
        sum_twice
    }

    public fun call_inline() {
        let _ = inline_double_add(3, 4);
    }
}


//# run 0xCAFE::TestAddition::add_and_return_sum --args 15u8 27u8


//# run 0xCAFE::TestAddition::call_lambda_example --args 7u8 8u8


//# run 0xCAFE::TestLambda::lambda_with_capture --args 5u8 2u8


//# run 0xCAFE::TestLambda::lambda_with_no_capture --args 20u8


//# run 0xCAFE::TestNestedCall::call_inline


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
