
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        // for example, return (a, a * 2)
        (a, a * 2)
    }
}


//# publish
module 0xCAFE::LambdaModule {
    public fun add_two_values_and_additional(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let sum = lambda(x, y);
        let additional = 5u8;
        sum + additional
    }

    public fun call_inline_function_from_other_module(a: u16): u16 {
        // call inline function f2 from 0xCAFE::MyModule
        let (a1, a2) = 0xCAFE::MyModule::f2(a);
        a1 + a2
    }
}


//# publish
module 0xCAFE::IntermediateModule {
    public fun call_lambda_module_addition(x: u8, y: u8): u8 {
        0xCAFE::LambdaModule::add_two_values_and_additional(x, y)
    }

    public fun call_lambda_module_inline_nested(a: u16): u16 {
        0xCAFE::LambdaModule::call_inline_function_from_other_module(a)
    }
}



//# run 0xCAFE::LambdaModule::add_two_values_and_additional --args 10u8 20u8



//# run 0xCAFE::LambdaModule::call_inline_function_from_other_module --args 3u16



//# run 0xCAFE::IntermediateModule::call_lambda_module_addition --args 7u8 8u8



//# run 0xCAFE::IntermediateModule::call_lambda_module_inline_nested --args 4u16
