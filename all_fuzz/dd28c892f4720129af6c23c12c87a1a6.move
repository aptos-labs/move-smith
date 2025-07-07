
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Just return x and x * 2 as a simple example
        (x, x * 2)
    }
}

//# publish
module 0xCAFE::FeatureTest {
    const CONST_VAL: u8 = 42;

    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;

        if (sum > 100) {
            CONST_VAL
        } else {
            sum
        };
        sum
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8|u8 has copy+drop = |a: u8| { a * 2 };
        f(x)
    }

    public fun call_inline_from_another_module(x: u16): (u16, u16) {
        0xCAFE::MyModule::f2(x)
    }

    // Correctly declare abilities only once here (e.g. after variant list)
    enum Flag has copy, drop {
        On,
        Off,
        Unknown,
    }
}



//# run 0xCAFE::FeatureTest::add_two --args 50u8 25u8



//# run 0xCAFE::FeatureTest::lambda_example --args 21u8



//# run 0xCAFE::FeatureTest::call_inline_from_another_module --args 5u16
