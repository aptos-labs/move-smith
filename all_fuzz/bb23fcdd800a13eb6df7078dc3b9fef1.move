
//# publish
module 0xCAFE::MyModule {
    // An inline function f2 that takes a u16 and returns a tuple of two u16 values.
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}

//# publish
module 0xCAFE::Adder {
    // A simple module to test addition of two u8 values and return a fixed u8 value.

    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        let fixed = 42u8;
        // ignore sum, always return fixed
        fixed
    }

    public fun add_with_lambda(a: u8, b: u8): u8 {
        // Lambda that sums two u8s and returns the result
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let result = lambda(a, b);
        result
    }

    public fun call_inline_from_other_module(a: u16): u16 {
        // Calls 0xCAFE::MyModule::f2 inline function and uses its returned tuple
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }
}



//# run 0xCAFE::Adder::add_then_return_fixed --args 10u8 20u8



//# run 0xCAFE::Adder::add_with_lambda --args 15u8 5u8



//# run 0xCAFE::Adder::call_inline_from_other_module --args 7u16
