
//# publish
module 0xCAFE::MathWithLambda {
    // Module to test addition of two u8 values and returning specific value

    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        add_lambda(x, y)
    }

    // Provide the missing function inline, replacing MyModule::f2
    // This function takes u16 and returns a tuple (u16, u16)
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }

    public fun test_nested_inline_call(x: u16): u32 {
        let (a, b) = Self::f2(x);
        (a as u32) + (b as u32)
    }
}



//# run 0xCAFE::MathWithLambda::add_and_return_special --args 3u8 5u8



//# run 0xCAFE::MathWithLambda::add_and_return_special --args 7u8 6u8



//# run 0xCAFE::MathWithLambda::test_lambda --args 10u8 20u8



//# run 0xCAFE::MathWithLambda::test_nested_inline_call --args 15u16
