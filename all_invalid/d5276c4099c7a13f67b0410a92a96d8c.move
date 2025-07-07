
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
        // Fix: Add parentheses around the inner function type to resolve parsing ambiguity
        let outer_lambda: |u8, (|u8| u8)| u8 has copy+drop = |val: u8, f: |u8| u8| {
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
