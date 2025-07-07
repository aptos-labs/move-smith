
//# publish
module 0xCAFE::MyModule {
    // Define inline function f2 that returns a tuple (u16, u16)
    public inline fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}

//# publish
module 0xCAFE::AdditionAndLambda {
    // Module to test addition and lambdas

    public fun add_two(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus 1 to check calculation
        sum + 1
    }

    public fun apply_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |a: u8, b: u8| {
            a + b
        };
        lambda(x, y)
    }

    public fun call_inline_from_other_module(x: u16): u16 {
        // Here call the inline function f2 from MyModule and sum the tuple to return a u16
        let (a, b) = 0xCAFE::MyModule::f2(x);
        a + b
    }
}



//# run 0xCAFE::AdditionAndLambda::add_two --args 10u8 20u8



//# run 0xCAFE::AdditionAndLambda::apply_lambda --args 15u8 25u8



//# run 0xCAFE::AdditionAndLambda::call_inline_from_other_module --args 5u16
