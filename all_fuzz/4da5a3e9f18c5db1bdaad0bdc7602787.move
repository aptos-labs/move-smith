
//# publish
module 0xCAFE::MyModule {
    // Define an inline function f2 that takes a u16 and returns a tuple (u16, u16)
    public inline fun f2(val: u16): (u16, u16) {
        (val * 2, val + 1)
    }
}

//# publish
module 0xCAFE::AddModule {
    // A simple function that adds two u8 values and returns their sum plus a constant offset
    public fun add_and_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        // Add an offset 10u8 to the sum and return
        sum + 10u8
    }

    public fun run_lambda_demo(a: u8, b: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x * y
        };
        lambda(a, b)
    }

    public fun call_inline_in_other_module(val: u16): u16 {
        // Call inline function f2 from 0xCAFE::MyModule
        let (res1, _) = 0xCAFE::MyModule::f2(val);
        res1
    }
}



//# run 0xCAFE::AddModule::add_and_offset --args 10u8 20u8



//# run 0xCAFE::AddModule::run_lambda_demo --args 3u8 4u8



//# run 0xCAFE::AddModule::call_inline_in_other_module --args 100u16
