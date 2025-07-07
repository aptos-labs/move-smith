
//# publish
module 0xCAFE::InlineFunc {

    // Inline function returning tuple (x+1, x+2)
    public inline fun increment_twice(x: u16): (u16, u16) {
        (x + 1u16, x + 2u16)
    }
}


//# publish
module 0xCAFE::LambdaTests {
    use 0xCAFE::InlineFunc;

    // Test function to add two u8 values and return u8
    public fun add_two_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed value plus sum to test addition
        sum + 10u8
    }

    // Function that contains a lambda and returns result of lambda applied
    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a * b + 1u8
        };
        lambda(x, y)
    }

    // Function that calls an inline function from another module (InlineFunc)
    // and adds the results
    public fun nested_inline_call(x: u16): u16 {
        let (val1, val2) = InlineFunc::increment_twice(x);
        val1 + val2
    }
}



//# run 0xCAFE::LambdaTests::add_two_values --args 5u8 7u8


//# run 0xCAFE::LambdaTests::apply_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaTests::nested_inline_call --args 10u16
