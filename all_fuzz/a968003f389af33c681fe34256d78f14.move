
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(x: u16): (u16, u16) {
        // Example inline function: returns (x, x * 2)
        (x, x * 2)
    }
}


//# publish
module 0xCAFE::LambdaDemo {
    // Removed unused import of std::vector;

    public fun add_with_lambda(a: u8, b: u8): u8 {
        let sum_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let added = sum_lambda(a, b);

        // Return a fixed value after calculating addition
        if (added > 10) {
            42u8
        } else {
            24u8
        }
    }

    public fun call_inline_from_other_module(a: u16): (u16, u16) {
        // Calls the inline function f2 from 0xCAFE::MyModule
        0xCAFE::MyModule::f2(a)
    }
}


//# run 0xCAFE::LambdaDemo::add_with_lambda --args 3u8 4u8


//# run 0xCAFE::LambdaDemo::add_with_lambda --args 8u8 7u8


//# run 0xCAFE::LambdaDemo::call_inline_from_other_module --args 15u16
