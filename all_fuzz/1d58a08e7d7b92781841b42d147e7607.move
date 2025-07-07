
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}

//# publish
module 0xCAFE::Adder {
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum < 10) {
            42u8
        } else {
            99u8
        }
    }

    public fun lambda_adder(): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let result = lambda(5u8, 6u8);
        result
    }

    public fun caller_of_inline(x: u16): (u16, u16) {
        // Calls the inline function f2 in MyModule
        0xCAFE::MyModule::f2(x)
    }
}



//# run 0xCAFE::Adder::add_and_return_special --args 3u8 4u8



//# run 0xCAFE::Adder::add_and_return_special --args 8u8 5u8



//# run 0xCAFE::Adder::lambda_adder



//# run 0xCAFE::Adder::caller_of_inline --args 15u16
