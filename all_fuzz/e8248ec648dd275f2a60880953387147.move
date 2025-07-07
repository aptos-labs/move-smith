
//# publish
module 0xCAFE::MyModule {
    public fun f2(a: u16): (u16, u16) {
        // Just return a tuple for testing
        (a + 1, a + 2)
    }
}

//# publish
module 0xCAFE::AddModule {
    // Module to test adding two u8 and returning a specific value
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum plus 10 for testing
        sum + 10
    }

    public fun test_lambda(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b + 1u8
        };
        lambda(x, y)
    }

    public fun test_nested_inline(a: u16): u16 {
        let (v1, v2) = 0xCAFE::MyModule::f2(a);
        v1 * v2
    }
}



//# run 0xCAFE::AddModule::add_and_return --args 3u8 4u8



//# run 0xCAFE::AddModule::test_lambda --args 5u8 6u8



//# run 0xCAFE::AddModule::test_nested_inline --args 7u16
