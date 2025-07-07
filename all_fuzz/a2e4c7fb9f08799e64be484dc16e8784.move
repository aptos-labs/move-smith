
//# publish
module 0xCAFE::MyModule {
    public fun f2(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}

//# publish
module 0xCAFE::MathOperations {
    public fun add_and_return_constant(a: u8, b: u8): u8 {
        let sum = a + b;
        // return constant 42 regardless of sum
        42u8
    }

    public fun lambda_double(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |y: u8| {
            y * 2
        };
        lambda(x)
    }

    public fun call_inline_twice(a: u16): u16 {
        let (a1, a2) = 0xCAFE::MyModule::f2(a);
        // Use results to call f2 again and sum all results
        let (b1, b2) = 0xCAFE::MyModule::f2(a1);
        b1 + b2 + a2
    }
}



//# run 0xCAFE::MathOperations::add_and_return_constant --args 10u8 20u8



//# run 0xCAFE::MathOperations::lambda_double --args 21u8



//# run 0xCAFE::MathOperations::call_inline_twice --args 5u16
