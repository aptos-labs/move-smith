
//# publish
module 0xCAFE::MyModule {
    // Example implementation of f2, returning a tuple of (a, a + 1)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::AddAndLambda {
    const RETURN_VALUE: u8 = 42;

    // Returns RETURN_VALUE after adding a and b to test computation and return
    public fun add_then_return(a: u8, b: u8): u8 {
        let sum = a + b;
        let _ = sum; // Consume the sum to emphasize addition
        RETURN_VALUE
    }

    // Returns the result of a lambda that doubles the input value
    public fun double_with_lambda(x: u8): u8 {
        let doubler: |u8| u8 has copy+drop = |val: u8| {
            val * 2u8
        };
        doubler(x)
    }

    // Calls an inline function from another module, returns sum of returned tuple components
    public fun call_inline_and_sum(a: u16): u16 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }
}



//# run 0xCAFE::AddAndLambda::add_then_return --args 10u8 20u8


//# run 0xCAFE::AddAndLambda::double_with_lambda --args 15u8


//# run 0xCAFE::AddAndLambda::call_inline_and_sum --args 100u16
