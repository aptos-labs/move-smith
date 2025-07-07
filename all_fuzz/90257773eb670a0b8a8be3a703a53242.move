
//# publish
module 0xCAFE::AddAndLambda {
    public fun add_two_values(a: u8, b: u8, flag: bool): u8 {
        let sum = a + b;
        if (flag) {
            sum + 1
        } else {
            sum
        }
    }

    public fun lambda_expression_example(): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add_lambda(10u8, 20u8)
    }

    // Since MyModule::f2 is not defined, we replace the call with a dummy implementation
    // providing the same return type (tuple of u16, u16).
    public fun f2(a: u16): (u16, u16) {
        // example dummy implementation
        (a, a)
    }

    public fun inline_call_nested(a: u16): u16 {
        let (a1, a2) = f2(a);
        a1 + a2
    }
}
