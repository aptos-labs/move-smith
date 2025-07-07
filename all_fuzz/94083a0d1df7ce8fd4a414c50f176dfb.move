
//# publish
module 0xCAFE::AdditionModule {
    public fun add_and_return_plus_ten(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 10
    }

    public fun lambda_example(x: u8, y: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| a + b;
        add_lambda(x, y)
    }

    public fun call_inline_lambda_on_sum(x: u8, y: u8): u8 {
        // Add self qualification with 'Self::' since the module is the current one
        let add_lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let inline_result = Self::inline_increment(a + b);
            inline_result
        };
        add_lambda(x, y)
    }

    public inline fun inline_increment(v: u8): u8 {
        v + 1
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::AdditionModule;

    public fun nested_call(a: u8, b: u8): u8 {
        let result = AdditionModule::add_and_return_plus_ten(a, b);
        let final_result = AdditionModule::inline_increment(result);
        final_result
    }

    public fun call_lambda_in_other_module(x: u8, y: u8): u8 {
        AdditionModule::lambda_example(x, y)
    }
}



//# run 0xCAFE::AdditionModule::add_and_return_plus_ten --args 4u8 5u8



//# run 0xCAFE::AdditionModule::lambda_example --args 7u8 8u8



//# run 0xCAFE::AdditionModule::call_inline_lambda_on_sum --args 3u8 6u8



//# run 0xCAFE::NestedCallModule::nested_call --args 10u8 5u8



//# run 0xCAFE::NestedCallModule::call_lambda_in_other_module --args 11u8 12u8
