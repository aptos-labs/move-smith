
//# publish
module 0xCAFE::MathOps {
    public fun add_two_values(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 as a specific value to differentiate
        sum + 10
    }

    public fun lambda_add_and_multiply(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        let s = add(x, y);
        let p = mul(x, y);
        (s, p)
    }
}




//# run 0xCAFE::MathOps::add_two_values --args 5u8 7u8




//# run 0xCAFE::MathOps::lambda_add_and_multiply --args 3u8 4u8




//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::MathOps;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        // Call add_two_values from MathOps module and add 5
        let result = MathOps::add_two_values(x, y);
        result + 5
    }

    public fun runner() {
        let _res = Self::call_inline_and_add(1u8, 2u8);
    }
}




//# run 0xCAFE::InlineCaller::call_inline_and_add --args 10u8 20u8




//# run 0xCAFE::InlineCaller::runner
