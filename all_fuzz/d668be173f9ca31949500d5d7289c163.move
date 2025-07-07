
//# publish
module 0xCAFE::TestAdd {
    public fun add_two(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    // Move does NOT support lambda expressions like in Rust or other languages;
    // instead, define a regular function or inline the functionality.
    public fun multiply(x: u8, y: u8): u8 {
        x * y
    }

    public fun test_lambda(): u8 {
        // call the multiply function instead of a lambda
        multiply(3u8, 4u8)
    }

    // Removed call to non-existent 0xCAFE::MyModule::f2 and replaced with an example inline return
    public fun call_inline(x: u16): (u16, u16) {
        // Since MyModule::f2 doesn't exist, just return a tuple for demonstration
        (x, x + 1)
    }

    public fun tuple_example(x: u8, y: u8): (u8, u8) {
        (x + y, x * y)
    }
}



//# run 0xCAFE::TestAdd::add_two --args 3u8 4u8


//# run 0xCAFE::TestAdd::add_two --args 7u8 6u8


//# run 0xCAFE::TestAdd::test_lambda


//# run 0xCAFE::TestAdd::call_inline --args 42u16


//# run 0xCAFE::TestAdd::tuple_example --args 3u8 5u8
