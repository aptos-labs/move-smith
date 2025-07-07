
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_addition(a: u16, b: u16): u16 {
        a + b
    }
}



//# publish
module 0xCAFE::AddAndLambda {
    public fun add_and_return_sum(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            10
        } else {
            sum
        }
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        sum_lambda(x, y)
    }

    public fun nested_inline_call(x: u8, y: u8): u16 {
        0xCAFE::InlineModule::inline_addition(x as u16, y as u16)
    }
}




//# run 0xCAFE::AddAndLambda::add_and_return_sum --args 5u8 4u8



//# run 0xCAFE::AddAndLambda::add_and_return_sum --args 6u8 7u8



//# run 0xCAFE::AddAndLambda::call_lambda --args 12u8 8u8



//# run 0xCAFE::AddAndLambda::nested_inline_call --args 10u8 15u8
