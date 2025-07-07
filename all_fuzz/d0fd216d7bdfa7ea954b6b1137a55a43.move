
//# publish
module 0xCAFE::AddAndLambdaTest {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        // We want to return 42 regardless to test computation and return.
        let _ = sum;
        42u8
    }

    public fun run_lambda_test(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        lambda(x, y)
    }
}



//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::AddAndLambdaTest;

    public inline fun inline_double_sum(a: u8, b: u8): u8 {
        let s = a + b;
        s + s
    }

    // Flatten the return type tuple, since Move does not support nested tuples.
    // Instead of (u8, (u8, u8), u8), return (u8, u8, u8, u8).
    public fun call_nested_functions(a: u8, b: u8): (u8, u8, u8, u8) {
        let add_ret = AddAndLambdaTest::add_and_return_constant(a, b);
        let (sum, product) = AddAndLambdaTest::run_lambda_test(a, b);
        let nested_sum = inline_double_sum(a, b);
        (add_ret, sum, product, nested_sum)
    }
}



//# run 0xCAFE::AddAndLambdaTest::add_and_return_constant --args 15u8 27u8



//# run 0xCAFE::AddAndLambdaTest::run_lambda_test --args 5u8 6u8



//# run 0xCAFE::NestedCallTest::call_nested_functions --args 4u8 7u8
