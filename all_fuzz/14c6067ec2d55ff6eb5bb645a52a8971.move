
//# publish
module 0xCAFE::MyModule {
    // Inline function f2 takes a u16 and returns a tuple (u16, u16)
    public inline fun f2(a: u16): (u16, u16) {
        (a, a * 2)
    }
}

//# publish
module 0xCAFE::TestFunctions {
    // Test function to add two u8 numbers and return the sum plus a constant
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    // Function returning a lambda that adds 10 to its input
    public fun get_adder_lambda(): |u8| u8 {
        |x: u8| {
            x + 10
        }
    }

    // Function that calls an inline function from another module and returns its results
    public fun call_my_module_f2_and_compute(a: u16): u32 {
        let (x, y) = 0xCAFE::MyModule::f2(a);
        // Return the sum casted to u32
        (x + y) as u32
    }
}



//# run 0xCAFE::TestFunctions::add_and_return_sum --args 3u8 7u8


//# run 0xCAFE::TestFunctions::get_adder_lambda


//# run 0xCAFE::TestFunctions::call_my_module_f2_and_compute --args 5u16
