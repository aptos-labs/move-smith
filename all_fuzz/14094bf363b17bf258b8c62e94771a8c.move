
//# publish
module 0xCAFE::InlineUtils {
    public inline fun inline_increment(x: u16): u16 {
        x + 1
    }
}


//# publish
module 0xCAFE::LambdaAdder {
    public fun add_two_values(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    public fun use_inline_function(a: u16): u16 {
        0xCAFE::InlineUtils::inline_increment(a)
    }
}



//# run 0xCAFE::LambdaAdder::add_two_values --args 10u8 20u8


//# run 0xCAFE::LambdaAdder::use_inline_function --args 42u16
