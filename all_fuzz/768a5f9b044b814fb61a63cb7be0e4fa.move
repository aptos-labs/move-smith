
//# publish
module 0xCAFE::MyModule {
    // provide the missing function f2 so that AddLambda can call it
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::AddLambda {
    public fun add_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        let result = if (sum > 10) {
            42u8
        } else {
            sum
        };
        result
    }

    public fun lambda_sum(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        sum_lambda(a, b)
    }

    public fun call_inline_from_other_module(x: u16): u32 {
        let (a, b) = 0xCAFE::MyModule::f2(x);
        (a as u32) + (b as u32)
    }
}



//# run 0xCAFE::AddLambda::add_u8 --args 5u8 4u8


//# run 0xCAFE::AddLambda::add_u8 --args 7u8 6u8


//# run 0xCAFE::AddLambda::lambda_sum --args 3u8 4u8


//# run 0xCAFE::AddLambda::call_inline_from_other_module --args 20u16
