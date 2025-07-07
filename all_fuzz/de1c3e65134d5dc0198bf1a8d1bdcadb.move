
//# publish
module 0xCAFE::LambdaTest {
    // Removed unused import `std::signer`
    public fun add_two_numbers(x: u8, y: u8): u8 {
        let sum = x + y;
        sum + 10u8
    }

    public fun use_lambda(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8|(u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let prod = a * b;
            (sum, prod)
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::LambdaTest::add_two_numbers --args 5u8 15u8



//# run 0xCAFE::LambdaTest::use_lambda --args 3u8 4u8



//# publish
module 0xCAFE::InlineModule {
    /// function f2 takes a u16 and returns a tuple (u16, u16)
    public fun f2(x: u16): (u16, u16) {
        // For example, return (x, x * 2)
        (x, x * 2)
    }
}



//# publish
module 0xCAFE::NestedInlineCall {
    use 0xCAFE::InlineModule;

    public fun call_inline_and_add(a: u16, b: u16): u16 {
        let (v1, v2) = InlineModule::f2(a);
        let (w1, w2) = InlineModule::f2(b);
        (v1 + v2) + (w1 + w2)
    }
}



//# run 0xCAFE::NestedInlineCall::call_inline_and_add --args 10u16 20u16
