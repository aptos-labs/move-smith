
//# publish
module 0xCAFE::LambdaTest {
    public fun add_then_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        // return sum + 1 to test addition and return
        sum + 1
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        let sum = add_lambda(x, y);
        sum
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}


//# publish
module 0xCAFE::NestedCallTest {
    use 0xCAFE::LambdaTest;

    public fun call_inline_and_lambda(x: u8, y: u8): u8 {
        let result_inline = LambdaTest::inline_add(x, y);
        let result_lambda = LambdaTest::lambda_example(x, y);
        // sum up the two results
        result_inline + result_lambda
    }
}


//# run 0xCAFE::LambdaTest::add_then_return_sum --args 10u8 20u8


//# run 0xCAFE::LambdaTest::lambda_example --args 15u8 25u8


//# run 0xCAFE::NestedCallTest::call_inline_and_lambda --args 5u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
