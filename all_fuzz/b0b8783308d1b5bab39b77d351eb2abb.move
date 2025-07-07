
//# publish
module 0xCAFE::Calc {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}



//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::Calc;

    public fun inline_summing(a: u8, b: u8): u8 {
        Calc::add_then_return_sum(a, b)
    }

    public fun caller_of_inline(a: u8, b: u8): u8 {
        inline_summing(a, b)
    }
}



//# run 0xCAFE::Calc::add_then_return_sum --args 12u8 30u8


//# run 0xCAFE::Calc::with_lambda --args 7u8 8u8


//# run 0xCAFE::InlineCall::inline_summing --args 15u8 25u8


//# run 0xCAFE::InlineCall::caller_of_inline --args 40u8 2u8
