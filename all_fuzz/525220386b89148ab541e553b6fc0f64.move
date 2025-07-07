
//# publish
module 0xCAFE::Arithmetic {
    public fun add_and_return_sum_then_ten(a: u8, b: u8): u8 {
        let _sum = a + b;
        10u8
    }

    public fun call_lambda_on_values(x: u8, y: u8): u8 {
        let double_sum_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let s = a + b;
            s * 2
        };
        double_sum_lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::Arithmetic::add_and_return_sum_then_ten --args 3u8 7u8



//# run 0xCAFE::Arithmetic::call_lambda_on_values --args 2u8 3u8



//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::Arithmetic;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let first = Arithmetic::inline_add(a, b);
        let second = Arithmetic::inline_add(second_value(a), second_value(b));
        let result = first + second;
        result
    }

    public inline fun second_value(x: u8): u8 {
        Arithmetic::inline_add(x, 1u8)
    }
}



//# run 0xCAFE::NestedCall::call_inline_and_add --args 4u8 5u8
