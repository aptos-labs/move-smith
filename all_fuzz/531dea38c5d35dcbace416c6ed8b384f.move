
//# publish
module 0xCAFE::MyModule {
    /// Returns a tuple of (a, a) for input a: u16
    public fun f2(a: u16): (u16, u16) {
        (a, a)
    }
}

//# publish
module 0xCAFE::AdditionModule {
    /// Adds two u8 numbers and returns their sum.
    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    /// Calls a lambda function that adds two u8 numbers.
    public fun lambda_add(x: u8, y: u8): u8 {
        let adder: |u8, u8|u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        adder(x, y)
    }

    /// Calls an inline function from another module to get a tuple and returns the sum.
    public fun call_inline_function(a: u16): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }
}



//# run 0xCAFE::AdditionModule::add --args 10u8 15u8



//# run 0xCAFE::AdditionModule::lambda_add --args 7u8 8u8



//# run 0xCAFE::AdditionModule::call_inline_function --args 20u16
