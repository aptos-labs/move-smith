
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_values(x: u8, y: u8): u8 {
        x + y
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun use_lambda_and_add(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda(x, y);
        sum + 10
    }

    public fun runner(): u8 {
        let val1 = add_u8_values(15u8, 10u8);
        let val2 = use_lambda(20u8, 5u8);
        let val3 = use_lambda_and_add(1u8, 2u8);
        val1 + val2 + val3
    }
}


//# run 0xCAFE::LambdaTest::add_u8_values --args 7u8 8u8


//# run 0xCAFE::LambdaTest::use_lambda --args 100u8 55u8


//# run 0xCAFE::LambdaTest::use_lambda_and_add --args 10u8 20u8


//# run 0xCAFE::LambdaTest::runner


//# publish
module 0xCAFE::Caller {
    use 0xCAFE::LambdaTest;

    public fun call_add_from_lambda_test(x: u8, y: u8): u8 {
        LambdaTest::add_u8_values(x, y)
    }

    public fun call_runner(): u8 {
        LambdaTest::runner()
    }
}


//# run 0xCAFE::Caller::call_add_from_lambda_test --args 3u8 4u8


//# run 0xCAFE::Caller::call_runner


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
