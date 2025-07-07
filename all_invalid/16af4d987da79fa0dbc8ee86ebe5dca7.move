//# publish
module 0xCAFE::TestModule {
    // Store a function with a higher-order type parameter
    public fun higher_order<F: pub_fun() -> ()>(f: fun() -> ()) {
        f();
    }

    // Function to be passed as argument
    public fun callback_func() {
        // empty
    }

    // Test function to invoke higher_order with a function parameter
    public fun test_higher_order() {
        higher_order<&0xCAFE::TestModule::callback_func>(&0xCAFE::TestModule::callback_func);
    }

    // Function with type parameter that is a number (to test proper type association)
    public fun compute<U: store + copy + drop>(value: U): U {
        value
    }

    // Inline function with type parameter
    public inline fun inline_generic<P: drop + store>(x: P): P {
        x
    }
}

//# run 0xCAFE::TestModule::test_higher_order --signers 0xCAFE
//# run 0xCAFE::TestModule::compute --signers 0xCAFE --args 42u64
//# run 0xCAFE::TestModule::inline_generic --signers 0xCAFE --args 10u8