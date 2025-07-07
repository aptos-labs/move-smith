
//# publish
module 0xCAFE::MathModule {
    public fun add_and_return_u8(a: u8, b: u8): u8 {
        let sum = a + b;
        42u8 + sum // returns sum + 42 as a test return value
    }

    public fun lambda_example(x: u8, y: u8): (u8, u8) {
        let add = |a: u8, b: u8| { a + b };
        let mul = |a: u8, b: u8| { a * b };
        let s = add(x, y);
        let p = mul(x, y);
        (s, p)
    }

    public inline fun f2(a: u16): (u16, u16) {
        // example function that returns a tuple (for use in CallerModule)
        (a, a * 2)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public inline fun call_inline_add(a: u16, b: u16): u16 {
        // Use the f2 function from MathModule to get a tuple result
        let (r1, r2) = MathModule::f2(a);
        (r1 + r2) + (a + b)
    }

    public fun call_add_and_lambda(a: u8, b: u8) {
        let added = MathModule::add_and_return_u8(a, b);
        let (sum, product) = MathModule::lambda_example(a, b);
        let inline_call = call_inline_add(10u16, 20u16);
        // Assign each variable separately to prevent tuple type error
        let _ = added;
        let _ = sum;
        let _ = product;
        let _ = inline_call;
    }
}



//# run 0xCAFE::MathModule::add_and_return_u8 --args 20u8 22u8



//# run 0xCAFE::MathModule::lambda_example --args 3u8 5u8



//# run 0xCAFE::CallerModule::call_add_and_lambda --args 7u8 11u8
