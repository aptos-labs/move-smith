
//# publish
module 0xCAFE::InlineMath {
    /// Inline function that increments input twice returning a tuple.
    public inline fun inline_increment_twice(x: u16): (u16, u16) {
        (x + 1, x + 2)
    }
}


//# publish
module 0xCAFE::Adder {
    /// Adds two u8 numbers and then adds 10 to the result.
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    /// Returns a lambda that adds a fixed number (5) to its u8 argument.
    public fun lambda_add_five(): |u8| u8 {
        let add_five = |x: u8| {
            x + 5
        };
        add_five
    }

    /// Calls an inline function from InlineMath module and multiplies result by 2.
    public fun nested_inline_call(x: u16): u16 {
        let (a, b) = 0xCAFE::InlineMath::inline_increment_twice(x);
        (a + b) * 2
    }
}


//# run 0xCAFE::Adder::add_and_offset --args 3u8 4u8


//# run 0xCAFE::Adder::lambda_add_five


//# run 0xCAFE::Adder::nested_inline_call --args 7u16
