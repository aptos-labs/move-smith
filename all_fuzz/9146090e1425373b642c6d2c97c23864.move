
//# publish
module 0xCAFE::AdditionModule {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        };
        42u8
    }

    public fun lambda_adder(): u8 {
        let add = |x: u8, y: u8| {
            x + y
        };
        add(7u8, 8u8)
    }

    public fun call_inline_and_lambda(x: u16, a: u8, b: u8): u8 {
        let (v1, v2) = Self::inline_add(x);
        let add = |x: u8, y: u8| { x + y };
        let sum_u8 = add(a, b);
        // Combine the results and return as u8 (ignoring overflow for test)
        let combined = ((v1 + v2) as u8) + sum_u8;
        combined
    }

    public inline fun inline_add(x: u16): (u16, u16) {
        (x + 3, x + 4)
    }
}



//# run 0xCAFE::AdditionModule::add_two_u8 --args 4u8 5u8



//# run 0xCAFE::AdditionModule::lambda_adder



//# run 0xCAFE::AdditionModule::call_inline_and_lambda --args 10u16 3u8 7u8
