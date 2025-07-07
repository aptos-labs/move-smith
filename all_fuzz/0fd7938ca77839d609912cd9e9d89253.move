
//# publish
module 0xCAFE::MyModule {
    // f2 is inline and returns a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::FeatureTest {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 200) {
            42u8
        } else {
            99u8
        }
    }

    public fun use_lambda(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(10u8, 15u8)
    }

    // Calls the inline function f2 from MyModule and sum the tuple results
    public fun inline_call_sum(a: u16): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }

    public fun runner() {
        let _ = add_two_values(100u8, 120u8);
        let _ = use_lambda();
        let _ = inline_call_sum(5u16);
    }
}



//# run 0xCAFE::FeatureTest::add_two_values --args 120u8 100u8


//# run 0xCAFE::FeatureTest::use_lambda


//# run 0xCAFE::FeatureTest::inline_call_sum --args 123u16


//# run 0xCAFE::FeatureTest::runner
