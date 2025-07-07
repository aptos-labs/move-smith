
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused 'use std::signer;'

    public fun add_u8(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun lambda_double(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |n: u8| { n * 2 };
        f(x)
    }

    public fun lambda_lift_test(): u8 {
        let f = |a: u8, b: u8| {
            let add = |x: u8, y: u8| { x + y };
            let sum = add(a, b);
            sum * 2
        };
        f(3u8, 4u8)
    }

    // Removed invalid spec `add_u8` with `update` clause to fix compilation error

    native public fun native_add(a: u8, b: u8): u8;
}



//# publish
module 0xCAFE::CallInlineFromOtherModule {
    use 0xCAFE::LambdaTest;

    public fun call_add_and_double(x: u8, y: u8): u8 {
        let s = LambdaTest::add_u8(x, y);
        let d = LambdaTest::lambda_double(s);
        d
    }
}




//# run 0xCAFE::LambdaTest::add_u8 --args 3u8 4u8




//# run 0xCAFE::LambdaTest::lambda_double --args 5u8




//# run 0xCAFE::LambdaTest::lambda_lift_test




//# run 0xCAFE::CallInlineFromOtherModule::call_add_and_double --args 2u8 3u8
