
//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 20) {
            42u8
        } else {
            sum
        }
    }

    public fun run_lambda_example(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        let result = lambda(6u8, 7u8);
        result
    }
}



//# run 0xCAFE::LambdaTest::add_two_u8 --args 10u8 15u8



//# run 0xCAFE::LambdaTest::add_two_u8 --args 5u8 6u8



//# run 0xCAFE::LambdaTest::run_lambda_example



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::LambdaTest;

    public inline fun inline_add(a: u16): u16 {
        let x = a + 5;
        x
    }

    public fun call_inline_add_twice(a: u16): u16 {
        let x = inline_add(a);
        let y = inline_add(x);
        y
    }

    public fun call_lambda_from_other_module(): u8 {
        let mult = LambdaTest::run_lambda_example();
        mult + 1u8
    }
}



//# run 0xCAFE::NestedCalls::call_inline_add_twice --args 10u16



//# run 0xCAFE::NestedCalls::call_lambda_from_other_module
