
//# publish
module 0xCAFE::MathModule {
    public fun add_and_return_special(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum == 42) {
            1u8
        } else {
            0u8
        }
    }

    public fun with_lambda(a: u8, b: u8): u8 {
        let adder: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        adder(a, b)
    }

    public inline fun inline_add(x: u8, y: u8): u8 {
        x + y
    }
}



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::MathModule;

    public fun call_inline_add(a: u8, b: u8): u8 {
        MathModule::inline_add(a, b)
    }

    public fun call_add_and_return_special(a: u8, b: u8): u8 {
        MathModule::add_and_return_special(a, b)
    }

    public fun call_with_lambda(a: u8, b: u8): u8 {
        MathModule::with_lambda(a, b)
    }

    public fun runner() {
        let _ = call_inline_add(10u8, 20u8);
        let _ = call_add_and_return_special(21u8, 21u8);
        let _ = call_with_lambda(5u8, 6u8);
    }
}



//# run 0xCAFE::MathModule::add_and_return_special --args 20u8 22u8


//# run 0xCAFE::MathModule::with_lambda --args 7u8 8u8


//# run 0xCAFE::CallerModule::call_inline_add --args 15u8 17u8


//# run 0xCAFE::CallerModule::call_add_and_return_special --args 40u8 2u8


//# run 0xCAFE::CallerModule::call_with_lambda --args 3u8 9u8


//# run 0xCAFE::CallerModule::runner
