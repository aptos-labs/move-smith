
//# publish
module 0xCAFE::AddWithLambda {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        let _lambda: |u8|u8 has copy+drop = |x: u8| {
            x + 1u8
        };
        _lambda(sum)
    }

    // Remove inline to make the function callable across modules
    public fun inline_increment(x: u8): u8 {
        x + 1
    }
}




//# run 0xCAFE::AddWithLambda::add_and_return_sum --args 10u8 15u8




//# run 0xCAFE::AddWithLambda::inline_increment --args 100u8




//# publish
module 0xCAFE::CallInline {
    use 0xCAFE::AddWithLambda;

    public fun call_add_and_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        let inc = AddWithLambda::inline_increment(sum);
        inc
    }
    
    public fun call_inline_directly(x: u8): u8 {
        AddWithLambda::inline_increment(x)
    }
}




//# run 0xCAFE::CallInline::call_add_and_increment --args 7u8 8u8




//# run 0xCAFE::CallInline::call_inline_directly --args 42u8

// IMPORTANT: Publish AddWithLambda **before** publishing CallInline to avoid FUNCTION_RESOLUTION_FAILURE.
