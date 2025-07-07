
//# publish
module 0xCAFE::MyModule {
    // This inline function returns a tuple of two u16 values derived from the input
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::Adder {
    public fun add_two_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return sum plus 10 to produce a specific return value
        sum + 10
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result + 5
    }

    // Call the inline function f2 in 0xCAFE::MyModule and return the sum of the tuple elements
    public fun call_inline_function(a: u16): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }
}


//# run 0xCAFE::Adder::add_two_u8 --args 7u8 8u8


//# run 0xCAFE::Adder::add_with_lambda --args 5u8 4u8


//# run 0xCAFE::Adder::call_inline_function --args 10u16
