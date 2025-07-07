// Fixed transactional test code


//# publish
module 0xCAFE::Calc {
    public fun add_then_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return a fixed value if sum is correct (for testing)
        if (sum == x + y) {
            42u8
        } else {
            0u8
        }
        // The if expression returns a u8, so no semicolon here to avoid returning unit
    }

    public fun lambda_test(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        let sum = add(x, y);
        let product = mul(x, y);
        (sum, product)
    }

    inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline(a: u8, b: u8): u8 {
        inline_add(a, b)
    }
}



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::Calc;

    public fun call_add_then_return(x: u8, y: u8): u8 {
        Calc::add_then_return(x, y)
    }

    public fun call_lambda_test(x: u8, y: u8): (u8, u8) {
        Calc::lambda_test(x, y)
    }

    public fun call_inline_add_from_calc(a: u8, b: u8): u8 {
        Calc::call_inline(a, b)
    }
}



//# run 0xCAFE::Calc::add_then_return --args 10u8 20u8



//# run 0xCAFE::Calc::lambda_test --args 3u8 4u8



//# run 0xCAFE::Calc::call_inline --args 7u8 8u8



//# run 0xCAFE::Caller::call_add_then_return --args 5u8 6u8



//# run 0xCAFE::Caller::call_lambda_test --args 2u8 3u8



//# run 0xCAFE::Caller::call_inline_add_from_calc --args 12u8 13u8
