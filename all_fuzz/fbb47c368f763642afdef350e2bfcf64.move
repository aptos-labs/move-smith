
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 10) {
            42u8
        } else if (sum > 10) {
            100u8
        } else {
            sum
        }
    }

    public fun lambda_test(): u8 {
        let f: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x * y };
        let result = f(3u8, 4u8);
        result
    }

    public fun call_inline_from_other_module(x: u16): u16 {
        // Call an inline function in 0xCAFE::MyModule and use its result
        let (v1, v2) = 0xCAFE::MyModule::f2(x);
        v1 + v2
    }
}



//# run 0xCAFE::AdditionTest::add_and_return_special --args 4u8 6u8



//# run 0xCAFE::AdditionTest::add_and_return_special --args 7u8 5u8



//# run 0xCAFE::AdditionTest::add_and_return_special --args 2u8 3u8



//# run 0xCAFE::AdditionTest::lambda_test



//# run 0xCAFE::AdditionTest::call_inline_from_other_module --args 10u16
