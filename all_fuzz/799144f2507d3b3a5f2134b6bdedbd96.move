
//# publish
module 0xCAFE::AddModule {
    /// Adds two u8 values and returns the result plus 10
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun run_lambda_example(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy+drop = |a: u8, b: u8| {
            let sum = a + b;
            let product = a * b;
            (sum, product)
        };
        lambda(x, y)
    }
}



//# run 0xCAFE::AddModule::add_and_offset --args 5u8 8u8



//# run 0xCAFE::AddModule::run_lambda_example --args 3u8 4u8



//# publish
module 0xCAFE::MyOtherModule {
    /// An inline function f2 that takes a u16 and returns a tuple of (u8, u8)
    public inline fun f2(x: u16): (u8, u8) {
        let a = (x / 2) as u8;
        let b = (x - (a as u16)) as u8;
        (a, b)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;
    use 0xCAFE::MyOtherModule;

    public fun call_inline_function(a: u16): (u16, u16) {
        // Call MyOtherModule::f2 to get tuple, then call AddModule::add_and_offset with one field to ensure cross-module call
        let (v1, v2) = MyOtherModule::f2(a);
        let sum_result = AddModule::add_and_offset(v1, v2);
        (v1 as u16, sum_result as u16)
    }
}



//# run 0xCAFE::CallerModule::call_inline_function --args 100u16
