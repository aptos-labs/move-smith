
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_five(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            5
        } else {
            5
        };
        5
    }

    public fun lambda_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        let tuple_lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let sum = x + y;
            let product = x * y;
            (sum, product)
        };
        tuple_lambda(a, b)
    }

    public fun runner() {
        let _ = add_then_return_five(3u8, 4u8);
        let _ = lambda_add(5u8, 6u8);
        let (_sum, _product) = lambda_return_tuple(2u8, 7u8);
    }
}


//# run 0xCAFE::LambdaTest::runner



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_inline_add_then_return_five(a: u8, b: u8): u8 {
        LambdaTest::add_then_return_five(a, b)
    }

    public fun call_lambda_add(a: u8, b: u8): u8 {
        LambdaTest::lambda_add(a, b)
    }

    public fun call_lambda_return_tuple(a: u8, b: u8): (u8, u8) {
        LambdaTest::lambda_return_tuple(a, b)
    }

    public fun runner() {
        let _ = call_inline_add_then_return_five(9u8, 5u8);
        let _ = call_lambda_add(7u8, 8u8);
        let (_sum, _product) = call_lambda_return_tuple(3u8, 4u8);
    }
}


//# run 0xCAFE::InlineCaller::runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
