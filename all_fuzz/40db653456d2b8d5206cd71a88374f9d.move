
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_adder(a: u16): u16 {
        let inline_lambda: |u16| u16 has copy+drop = |x: u16| { x + 5 };
        inline_lambda(a + 1)
    }
}



//# publish
module 0xCAFE::LambdaTest {
    // Import the InlineModule to fix the "unbound module" error
    use 0xCAFE::InlineModule;

    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum == 10) {
            100u8
        } else {
            0u8
        }
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun nested_inline_call(a: u16): u16 {
        InlineModule::inline_adder(a)
    }
}



//# run 0xCAFE::LambdaTest::add_and_return_special --args 7u8 3u8



//# run 0xCAFE::LambdaTest::add_and_return_special --args 2u8 3u8



//# run 0xCAFE::LambdaTest::apply_lambda --args 4u8 5u8



//# run 0xCAFE::LambdaTest::nested_inline_call --args 5u16
