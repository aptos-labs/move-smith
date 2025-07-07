
//# publish
module 0xCAFE::MyModule {
    /// Inline function that returns a tuple of (input, input + 5)
    // inline]
    public fun f2(x: u16): (u16, u16) {
        (x, x + 5)
    }
}

//# publish
module 0xCAFE::TestAddition {
    /// Adds two u8 values and returns the sum plus a fixed offset 10u8.
    public fun add_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10u8
    }

    /// Returns the sum of two u8 numbers using a lambda expression.
    public fun add_lambda(a: u8, b: u8): u8 {
        let add: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        add(a, b)
    }

    /// Calls the inline function `f2` from 0xCAFE::MyModule with input 15u16,
    /// then returns the sum of the tuple results converted to u16.
    public fun call_inline_and_sum(): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(15u16);
        x + y
    }

    /// Runner function that calls all above functions for testing.
    public fun runner(): (u8, u8, u16) {
        let val1 = add_with_offset(7u8, 8u8);
        let val2 = add_lambda(9u8, 6u8);
        let val3 = call_inline_and_sum();
        (val1, val2, val3)
    }
}



//# run 0xCAFE::TestAddition::add_with_offset --args 5u8 6u8



//# run 0xCAFE::TestAddition::add_lambda --args 20u8 22u8



//# run 0xCAFE::TestAddition::call_inline_and_sum



//# run 0xCAFE::TestAddition::runner
