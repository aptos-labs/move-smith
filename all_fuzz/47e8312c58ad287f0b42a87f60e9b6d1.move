
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}

//# publish
module 0xCAFE::Computation {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_add_mul(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |x: u8, y: u8| {
            let add_result = x + y;
            let mul_result = x * y;
            (add_result, mul_result)
        };
        lambda(a, b)
    }

    public fun call_inline_and_return(a: u16): u16 {
        let (val1, val2) = 0xCAFE::MyModule::f2(a);
        val1 + val2
    }
}



//# run 0xCAFE::Computation::add_then_return_sum --args 10u8 15u8



//# run 0xCAFE::Computation::lambda_add_mul --args 5u8 6u8



//# run 0xCAFE::Computation::call_inline_and_return --args 20u16
