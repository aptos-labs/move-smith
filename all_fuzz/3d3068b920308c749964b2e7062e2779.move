
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_sum(a: u8, b: u8): u8 {
        let sum = a + b;
        sum
    }

    public fun lambda_double_increment(x: u8): u8 {
        // Move does NOT support local anonymous functions.
        // So we define the increment inline directly instead.
        let inc_x = x + 1;
        let doubled = inc_x + inc_x;
        doubled
    }

    public inline fun inline_increment(x: u8): u8 {
        x + 1u8
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_increment(x: u8): u8 {
        // Call inline function from AdditionModule
        AdditionModule::inline_increment(x)
    }

    public fun call_add_and_return_sum(a: u8, b: u8): u8 {
        // Call add_and_return_sum from AdditionModule
        AdditionModule::add_and_return_sum(a, b)
    }

    public fun call_lambda_double_increment(x: u8): u8 {
        // Call lambda_double_increment from AdditionModule
        AdditionModule::lambda_double_increment(x)
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_sum --args 3u8 7u8



//# run 0xCAFE::AdditionModule::lambda_double_increment --args 4u8



//# run 0xCAFE::NestedCallModule::call_inline_increment --args 9u8



//# run 0xCAFE::NestedCallModule::call_add_and_return_sum --args 5u8 10u8



//# run 0xCAFE::NestedCallModule::call_lambda_double_increment --args 6u8
