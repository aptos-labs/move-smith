
//# publish
module 0xCAFE::MyModule {
    // Assuming f2 is intended to be defined here as it was missing.
    public fun f2(x: u16): (u16, u16) {
        (x, x) // just returning a tuple of two identical u16 values as an example
    }
}


//# publish
module 0xCAFE::AddModule {
    public fun add_then_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun call_with_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        lambda(a, b)
    }

    public fun call_inline_and_lambda(a: u8, b: u8): u8 {
        let lambda: |u8| u8 has copy + drop = |x: u8| {
            // Calls the inline function in another module with a convert to u16
            let (r, _) = 0xCAFE::MyModule::f2(x as u16);
            r as u8
        };
        let res_from_lambda = lambda(a);
        let res_add = call_with_lambda(res_from_lambda, b);
        res_add
    }
}



//# run 0xCAFE::AddModule::add_then_return_sum --args 7u8 8u8



//# run 0xCAFE::AddModule::call_with_lambda --args 10u8 15u8



//# run 0xCAFE::AddModule::call_inline_and_lambda --args 5u8 3u8
