
//# publish
module 0xCAFE::AdditionModule {
    public fun add_then_return_10(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed 10 regardless of sum to differentiate behavior
        10
    }

    // Move currently does not support lambda (anonymous function) syntax.
    // Instead, define a regular public function.
    public fun lambda_example(): u8 {
        add(5u8, 7u8)
    }

    // Helper function that replaces the lambda function
    public fun add(x: u8, y: u8): u8 {
        x + y
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        AdditionModule::inline_add(a, b)
    }

    public fun call_lambda_example(): u8 {
        AdditionModule::lambda_example()
    }

    public fun run_all(): u8 {
        let val1 = add_then_return_10_wrapper(3u8, 4u8);
        let val2 = call_inline_add(20u8, 22u8);
        let val3 = call_lambda_example();
        val1 + val2 + val3
    }

    fun add_then_return_10_wrapper(a: u8, b: u8): u8 {
        // Call the add_then_return_10 function in AdditionModule
        AdditionModule::add_then_return_10(a, b)
    }
}



//# run 0xCAFE::AdditionModule::add_then_return_10 --args 2u8 3u8



//# run 0xCAFE::AdditionModule::lambda_example



//# run 0xCAFE::NestedCallModule::call_inline_add --args 15u8 25u8



//# run 0xCAFE::NestedCallModule::call_lambda_example



//# run 0xCAFE::NestedCallModule::run_all
