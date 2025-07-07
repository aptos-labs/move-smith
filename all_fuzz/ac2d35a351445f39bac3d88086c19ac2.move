
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}


//# publish
module 0xCAFE::LambdaTest {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to differentiate from simple sum
        sum + 10u8
    }

    public fun apply_lambda(x: u8): u8 {
        let lambda: |u8| u8 has copy+drop = |v: u8| {
            v * 2u8
        };
        lambda(x)
    }

    public fun call_inline_from_other_module(x: u16): u16 {
        // Calls inline function f2 from 0xCAFE::MyModule,
        // get first element of the tuple and add 5
        let (a, _b) = 0xCAFE::MyModule::f2(x);
        a + 5u16
    }
}



//# run 0xCAFE::LambdaTest::add_two_u8 --args 20u8 15u8


//# run 0xCAFE::LambdaTest::apply_lambda --args 21u8


//# run 0xCAFE::LambdaTest::call_inline_from_other_module --args 7u16
