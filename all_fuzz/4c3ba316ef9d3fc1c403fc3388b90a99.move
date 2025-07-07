
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        // Example implementation: return (x, x)
        (x, x)
    }
}


//# publish
module 0xCAFE::AdditionTest {
    public fun add_and_return_fixed(x: u8, y: u8): u8 {
        let sum = x + y;
        assert!(sum >= x, 100); // simple check to ensure addition did not underflow
        42u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public fun nested_inline(x: u16): u16 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }
}




//# run 0xCAFE::AdditionTest::add_and_return_fixed --args 10u8 15u8



//# run 0xCAFE::AdditionTest::use_lambda --args 7u8 8u8



//# run 0xCAFE::AdditionTest::nested_inline --args 100u16
