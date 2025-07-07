
//# publish
module 0xCAFE::AddModule {
    public fun add_and_return(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 5 to check calculation
        sum + 5
    }

    public fun with_lambda_example(x: u8, y: u8): u8 {
        let adder: |u8, u8| u8 has copy+drop = |a: u8, b: u8| { a + b };
        adder(x, y)
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddModule;

    // Function that calls inline function from AddModule
    public fun call_add_and_return(x: u8, y: u8): u8 {
        AddModule::add_and_return(x, y)
    }

    public fun call_lambda(x: u8, y: u8): u8 {
        AddModule::with_lambda_example(x, y)
    }
}



//# run 0xCAFE::AddModule::add_and_return --args 3u8 4u8



//# run 0xCAFE::AddModule::with_lambda_example --args 7u8 2u8



//# run 0xCAFE::CallerModule::call_add_and_return --args 5u8 5u8



//# run 0xCAFE::CallerModule::call_lambda --args 8u8 1u8
