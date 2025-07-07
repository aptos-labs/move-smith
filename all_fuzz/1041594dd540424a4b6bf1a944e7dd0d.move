
//# publish
module 0xCAFE::TestAdd {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return the sum plus 10 as a fixed offset
        sum + 10
    }

    public fun lambda_addition(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }
}



//# publish
module 0xCAFE::InlineCall {
    use 0xCAFE::TestAdd;

    // Removed inline visibility; inline functions must be public but not inline (or compiler may not find implementation)
    public fun call_add_and_return(x: u8, y: u8): u8 {
        TestAdd::add_and_return(x, y)
    }

    public fun runner(): u8 {
        let a = 5u8;
        let b = 7u8;
        call_add_and_return(a, b)
    }
}



//# run 0xCAFE::TestAdd::add_and_return --args 12u8 13u8


//# run 0xCAFE::TestAdd::lambda_addition --args 20u8 22u8


//# run 0xCAFE::InlineCall::call_add_and_return --args 15u8 25u8


//# run 0xCAFE::InlineCall::runner
