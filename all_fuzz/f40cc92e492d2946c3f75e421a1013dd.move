
//# publish
module 0xCAFE::AddAndLambda {
    // Module to test addition and lambda expressions

    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum + 10 to check computation
        sum + 10
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::AddAndLambda;

    public fun nested_call_with_inline(x: u8, y: u8): u8 {
        let val1 = AddAndLambda::inline_add(x, y);
        let val2 = AddAndLambda::add_and_return_sum(val1, y);
        val2
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return_sum --args 20u8 22u8



//# run 0xCAFE::AddAndLambda::lambda_example --args 15u8 5u8



//# run 0xCAFE::NestedCalls::nested_call_with_inline --args 3u8 7u8



//# run 0xCAFE::AddAndLambda::add_and_return_sum --args 1u8 2u8
