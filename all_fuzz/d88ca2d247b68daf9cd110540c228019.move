
//# publish
module 0xCAFE::LambdaTest {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 5u8 6u8



//# run 0xCAFE::LambdaTest::add_and_return_fixed --args 2u8 3u8



//# run 0xCAFE::LambdaTest::call_lambda --args 10u8 15u8


// Note you must publish LambdaTest module before publishing InlineCaller module


//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun inline_caller_inner(a: u8): u8 {
        let result = LambdaTest::call_lambda(a, 1u8);
        result + 1u8
    }

    public fun runner(): u8 {
        inline_caller_inner(10u8)
    }
}



//# run 0xCAFE::InlineCaller::runner
