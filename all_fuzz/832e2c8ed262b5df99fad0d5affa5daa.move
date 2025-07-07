
//# publish
module 0xCAFE::LambdaTest {
    public fun add_u8_values(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            24u8
        };
        100u8
    }

    public fun use_lambda(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        adder(x, y)
    }

    // Moved the inline_add_two_values function inside the same module (no duplicate module definitions)
    public inline fun inline_add_two_values(a: u16): (u16, u16) {
        (a + 10, a + 20)
    }
}



//# run 0xCAFE::LambdaTest::add_u8_values --args 3u8 5u8



//# run 0xCAFE::LambdaTest::use_lambda --args 7u8 8u8



//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaTest;

    public inline fun call_inline_function(a: u16): (u16, u16) {
        // Inline function must return tuple, test how nested calls are handled
        LambdaTest::inline_add_two_values(a)
    }

    public fun nested_call(a: u16): u16 {
        let (x, y) = call_inline_function(a);
        x + y
    }
}



//# run 0xCAFE::InlineCaller::nested_call --args 15u16
