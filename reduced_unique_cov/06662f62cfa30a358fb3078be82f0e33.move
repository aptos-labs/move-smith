
//# publish
module 0xCAFE::LambdaModule {
    use aptos_framework::debug;

    public fun add_two_u8s_with_offset(a: u8, b: u8): u8 {
        let sum = a + b;
        let offset = 5u8;
        sum + offset
    }

    public fun lambda_example(x: u8): u8 {
        let add_three: |u8|u8 has copy+drop = |v: u8| v + 3;
        add_three(x)
    }

    public fun nested_lambda(x: u8, y: u8): u8 {
        let make_adder: |u8| (|u8|u8) has copy+drop = |offset: u8| {
            let adder: |u8|u8 has copy+drop = |num: u8| num + offset;
            adder
        };
        let adder_fn = make_adder(x);
        adder_fn(y)
    }

    public inline fun inline_increment(a: u8): u8 {
        a + 1
    }
}



//# publish
module 0xCAFE::NestedCallModule {
    use 0xCAFE::LambdaModule;
    use aptos_framework::debug;

    public fun call_inline_increment(a: u8): u8 {
        LambdaModule::inline_increment(a)
    }

    public fun call_lambda_and_print(x: u8, y: u8) {
        let result = LambdaModule::nested_lambda(x, y);
        debug::print(&result);
    }

    public fun call_add_two_and_print(a: u8, b: u8) {
        let sum = LambdaModule::add_two_u8s_with_offset(a, b);
        debug::print(&sum);
    }
}



//# run 0xCAFE::LambdaModule::add_two_u8s_with_offset --args 10u8 20u8




//# run 0xCAFE::LambdaModule::lambda_example --args 7u8




//# run 0xCAFE::LambdaModule::nested_lambda --args 4u8 5u8




//# run 0xCAFE::LambdaModule::inline_increment --args 9u8




//# run 0xCAFE::NestedCallModule::call_inline_increment --args 100u8




//# run 0xCAFE::NestedCallModule::call_lambda_and_print --args 2u8 6u8




//# run 0xCAFE::NestedCallModule::call_add_two_and_print --args 3u8 14u8
