
//# publish
module 0xCAFE::AddAndCompute {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_lambda_example(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        lambda(a, b)
    }
}


//# run 0xCAFE::AddAndCompute::add_and_return_sum --args 5u8 7u8


//# run 0xCAFE::AddAndCompute::call_lambda_example --args 3u8 4u8


//# publish
module 0xCAFE::NestedInlineCaller {
    use 0xCAFE::AddAndCompute;

    public inline fun inline_caller(x: u8, y: u8): u8 {
        AddAndCompute::add_and_return_sum(x, y)
    }

    public fun runner(): u8 {
        inline_caller(10u8, 15u8)
    }
}


//# run 0xCAFE::NestedInlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
