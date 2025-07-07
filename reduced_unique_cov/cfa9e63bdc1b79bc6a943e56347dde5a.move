
//# publish
module 0xCAFE::LambdaTest {
    use std::signer;

    public fun add_two_values_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let _fixed_value = 42u8;
        assert!(sum < 100, 777);
        _fixed_value
    }

    public fun lambda_example(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public fun nested_lambda_usage(): u8 {
        let inner_lambda: |u8| u8 has copy+drop = |x: u8| {
            x * 2
        };
        let outer_lambda: |u8, |u8| u8| u8 has copy+drop = |val: u8, f: |u8| u8| {
            f(val) + 10u8
        };
        outer_lambda(5u8, inner_lambda)
    }

    public fun call_inline_and_lambda(a: u16, b: u8): (u16, u8) {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        let sum = lambda_example(b, (x as u8));
        (y, sum)
    }
}


//# run 0xCAFE::LambdaTest::add_two_values_and_return_fixed --args 20u8 21u8


//# run 0xCAFE::LambdaTest::lambda_example --args 15u8 25u8


//# run 0xCAFE::LambdaTest::nested_lambda_usage


//# run 0xCAFE::LambdaTest::call_inline_and_lambda --args 10u16 7u8


// Featurres:
// e0d671ef5e56e3c17cc028f58558e133: Test that the Move function correctly computes the addition of two u8 values before returning a specific value.
// 02a0d162ad59e2910b98dd07a8d9cb41: Write functions containing lambda (anonymous function) expressions.
// 9f38a2013886067cef890651dcf5f9f0: Test that calling an inline function from one module within another module correctly performs the nested function calls and returns the expected result.
