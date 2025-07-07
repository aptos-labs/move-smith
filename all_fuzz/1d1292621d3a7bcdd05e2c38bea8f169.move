
//# publish
module 0xCAFE::CalcModule {
    // Module to test addition and inline function invocation
    public fun add_u8(x: u8, y: u8): u8 {
        x + y
    }

    public inline fun add_three_times(x: u8, y: u8): u8 {
        let sum = add_u8(x, y);
        sum + 3u8
    }

    public fun run_lambda_expr() {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a + b
        };
        let _res = lambda(5u8, 7u8);
    }

    public fun call_inline_from_another_module(x: u8, y: u8): u8 {
        let partial = add_u8(x, y);
        // Use inline function based on result
        add_three_times(partial, 1u8)
    }

    // Removed the native function to fix MISSING_DEPENDENCY error.
    // Instead, use a dummy spec-wrapper function implemented normally.

    public fun spec_wrapper(): u8 {
        42u8
    }

    public fun loop_iterator_access(): u8 {
        let sum = 0u8;
        for (i in 0..5) {
            sum = sum + i;
        };
        sum
    }
}



//# publish
module 0xCAFE::CallInlineModule {
    use 0xCAFE::CalcModule;

    public fun call_calc_inline(x: u8, y: u8): u8 {
        CalcModule::call_inline_from_another_module(x, y)
    }
}



//# run 0xCAFE::CalcModule::add_u8 --args 10u8 12u8


//# run 0xCAFE::CalcModule::run_lambda_expr


//# run 0xCAFE::CalcModule::call_inline_from_another_module --args 4u8 5u8


//# run 0xCAFE::CalcModule::spec_wrapper


//# run 0xCAFE::CalcModule::loop_iterator_access


//# run 0xCAFE::CallInlineModule::call_calc_inline --args 7u8 8u8
