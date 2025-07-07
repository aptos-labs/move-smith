
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_return(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return a fixed offset plus the sum
        sum + 10u8
    }

    // Move currently does not support lambda (anonymous function) expressions.
    // Replacing the lambda with a named function inside the module.

    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        add(a, b) + 5u8
    }
}



//# run 0xCAFE::AddAndReturn::add_and_return --args 12u8 30u8



//# run 0xCAFE::AddAndReturn::with_lambda --args 3u8 7u8


// Note: The 0xCAFE::AddAndReturn module must be published before publishing CallerModule.


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndReturn;

    public fun call_inline(a: u8, b: u8): u8 {
        AddAndReturn::add_and_return(a, b)
    }
}



//# run 0xCAFE::CallerModule::call_inline --args 25u8 17u8
