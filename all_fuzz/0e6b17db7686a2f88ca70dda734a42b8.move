
//# publish
module 0xCAFE::MyModule {
    public inline fun f2(x: u8): u8 {
        x + 1
    }

    public inline fun f1(x: u8, flag: bool): u8 {
        if (flag) {
            f2(x)
        } else {
            x
        }
    }
}


//# publish
module 0xCAFE::Calc {
    public fun add_then_check(a: u8, b: u8): u8 {
        let sum = a + b;
        // The if expression should be used to produce a value or removed
        // Here it's unused so remove or fix.
        if (sum < 100) {
            // no-op boolean, just ignore, or use it meaningfully
        };

        // Return a specific value after addition
        42u8
    }

    public fun lambda_usage(x: u8, y: u8): (u8, u8) {
        let sum_lambda: |u8, u8| (u8) has copy+drop = |a: u8, b: u8| { a + b };
        let prod_lambda: |u8, u8| (u8) has copy+drop = |a: u8, b: u8| { a * b };
        let s = sum_lambda(x, y);
        let p = prod_lambda(x, y);
        (s, p)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_from_other_module(x: u8, y: u8): u8 {
        // Call inline function from MyModule::f1 which itself calls f2 inline internally
        let res = 0xCAFE::MyModule::f1(x, true);
        let inline_res = inline_add(x, y);
        res + inline_res
    }
}



//# publish
module 0xBEEF::Caller {
    use 0xCAFE::Calc;

    public fun caller_lambda(x: u8, y: u8): (u8, u8) {
        Calc::lambda_usage(x, y)
    }

    public fun caller_add_and_check(a: u8, b:u8): u8 {
        Calc::add_then_check(a, b)
    }

    public fun caller_inline_and_nested(x: u8, y: u8): u8 {
        Calc::call_inline_from_other_module(x, y)
    }
}



//# run 0xCAFE::Calc::add_then_check --args 10u8 20u8



//# run 0xCAFE::Calc::lambda_usage --args 5u8 6u8



//# run 0xCAFE::Calc::call_inline_from_other_module --args 2u8 3u8



//# run 0xBEEF::Caller::caller_lambda --args 4u8 5u8



//# run 0xBEEF::Caller::caller_add_and_check --args 7u8 8u8



//# run 0xBEEF::Caller::caller_inline_and_nested --args 1u8 2u8
