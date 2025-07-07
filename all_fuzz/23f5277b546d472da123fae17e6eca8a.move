
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}

//# publish
module 0xCAFE::MathModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun with_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        lambda(x, y)
    }

    public fun call_inline_fn(a: u16): u16 {
        // call the inline function from MyModule to get tuple and return sum of both elements
        let (x, y) = 0xCAFE::MyModule::f2(a);
        x + y
    }
}



//# run 0xCAFE::MathModule::add_and_return_sum --args 10u8 15u8



//# run 0xCAFE::MathModule::with_lambda --args 20u8 22u8



//# run 0xCAFE::MathModule::call_inline_fn --args 10u16
