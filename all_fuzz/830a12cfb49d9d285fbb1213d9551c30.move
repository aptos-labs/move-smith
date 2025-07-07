
//# publish
module 0xCAFE::Calc {
    public fun add_then_return_special(a: u8, b: u8): u8 {
        let _sum = a + b; // avoid unused var warning
        // Return a fixed value regardless
        42u8
    }

    public fun uses_lambda_and_adds(a: u8, b: u8): u8 {
        let add_lambda: |u8, u8| u8 has copy+drop = |x: u8, y: u8| { x + y };
        add_lambda(a, b)
    }

    public fun uses_lambda_to_transform(a: u8, f: |u8| u8): u8 {
        f(a)
    }

    // Moved these wrapper functions inside the module for proper publishing
    public fun run_uses_lambda_to_transform_with_inc(a: u8): u8 {
        Self::uses_lambda_to_transform(a, |x| x + 1)
    }

    public fun run_uses_lambda_to_transform_with_double(a: u8): u8 {
        Self::uses_lambda_to_transform(a, |x| x * 2)
    }
}



//# run 0xCAFE::Calc::add_then_return_special --args 3u8 4u8



//# run 0xCAFE::Calc::uses_lambda_and_adds --args 10u8 20u8


//# run 0xCAFE::Calc::run_uses_lambda_to_transform_with_inc --args 5u8


//# run 0xCAFE::Calc::run_uses_lambda_to_transform_with_double --args 5u8




//# publish
module 0xCAFE::MyModule {
    // Add f2, used by NestedCall below.
    public fun f2(x: u16): (u16, u16) {
        (x, x + 1)
    }
}




//# publish
module 0xCAFE::NestedCall {
    use 0xCAFE::MyModule;

    public fun inline_call_via_another_module(x: u16): u16 {
        let (a, b) = MyModule::f2(x);
        a + b
    }

    public fun runner(): u16 {
        inline_call_via_another_module(10u16)
    }
}




//# run 0xCAFE::NestedCall::inline_call_via_another_module --args 7u16



//# run 0xCAFE::NestedCall::runner
