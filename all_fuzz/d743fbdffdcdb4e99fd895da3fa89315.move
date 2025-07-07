
//# publish
module 0xCAFE::Utils {
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}


//# publish
module 0xCAFE::AddLambda {
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == a + b) {
            42u8
        } else {
            0u8
        }
    }

    public fun apply_lambda_to_add(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_inline_from_my_module(x: u16): u16 {
        let (a, b) = 0xCAFE::Utils::f2(x);
        a + b
    }

    public fun runner() {
        let _res1 = add_two_values(10u8, 32u8);
        let _res2 = apply_lambda_to_add(5u8, 7u8);
        let _res3 = call_inline_from_my_module(20u16);
    }
}



//# run 0xCAFE::AddLambda::runner
