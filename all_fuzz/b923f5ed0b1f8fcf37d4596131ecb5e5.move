
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_values(x: u8, y: u8): u8 {
        let result = x + y;
        // Return result plus a constant 5
        result + 5
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_increment(value: u8): u8 {
        value + 1
    }

    public fun runner(): u8 {
        let val = 10u8;
        let freshly_incremented = inline_increment(val);
        freshly_incremented
    }
}


//# run 0xCAFE::LambdaTest::add_two_values --args 7u8 8u8


//# run 0xCAFE::LambdaTest::with_lambda --args 12u8 3u8


//# run 0xCAFE::LambdaTest::runner



//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::LambdaTest;

    public fun call_inline_plus(x: u8): u8 {
        let incremented = LambdaTest::inline_increment(x);
        incremented + 5
    }

    public fun call_runner_and_add(): u8 {
        let value_from_runner = LambdaTest::runner();
        value_from_runner + 10
    }

    public fun test_lambda_and_add(x: u8, y: u8): u8 {
        let sum = LambdaTest::with_lambda(x, y);
        sum + 20
    }
}


//# run 0xCAFE::CallInline::call_inline_plus --args 15u8


//# run 0xCAFE::CallInline::call_runner_and_add


//# run 0xCAFE::CallInline::test_lambda_and_add --args 8u8 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
