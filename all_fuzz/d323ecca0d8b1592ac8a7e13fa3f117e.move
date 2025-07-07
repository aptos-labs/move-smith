
//# publish
module 0xCAFE::HelperModule {
    /// Inline function that takes a u16 and returns a tuple (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::AddAndLambda {
    /// Adds two u8 values and then returns a fixed u8 value 42
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;
        // Just return 42 regardless of sum to verify flow
        42
    }

    /// Returns a lambda that multiplies two u8 values
    public fun get_multiplier_lambda(): |u8, u8| u8 {
        |x: u8, y: u8| {
            x * y
        }
    }

    /// Use the inline function from 0xCAFE::HelperModule and return its result plus 1
    public fun call_inline_function(a: u16): u16 {
        // Call inline function f2 from HelperModule
        let (v1, v2) = 0xCAFE::HelperModule::f2(a);
        // Return sum + 1 for extra test of manipulation of returned tuple data
        v1 + v2 + 1
    }
}



//# run 0xCAFE::AddAndLambda::add_then_return_fixed --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::get_multiplier_lambda


//# run 0xCAFE::AddAndLambda::call_inline_function --args 5u16
