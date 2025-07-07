
//# publish
module 0xCAFE::AddAndLambda {
    // Removed unused std::vector import

    struct Pair has copy, drop, store {
        a: u8,
        b: u8,
    }

    public fun add_and_return_result(x: u8, y: u8): u8 {
        let sum = x + y;
        // Return sum + 10 as a specific value to test correct addition
        sum + 10
    }

    public fun lambda_example(x: u8): u8 {
        let f: |u8| u8 has copy+drop = |v: u8| {
            v * 2
        };
        f(x)
    }

    public inline fun inline_double(a: u8): u8 {
        a * 2
    }

    public fun call_inline_double(a: u8): u8 {
        inline_double(a)
    }

    enum Flag has copy, drop {
        On,
        Off(u8),
        Custom { val: u8 },
    }

    public fun match_flag(flag: u8): u8 {
        // Convert the u8 arg into the appropriate Flag variant for testing
        let f = 
            if (flag == 0) {
                Flag::On
            } else if (flag == 1) {
                Flag::Off(5)
            } else {
                Flag::Custom { val: 10 }
            };
        let res = match (f) {
            Flag::On => 1,
            Flag::Off(v) => v,
            Flag::Custom { val } => val + 1,
        };
        res
    }
}



//# run 0xCAFE::AddAndLambda::add_and_return_result --args 5u8 10u8


//# run 0xCAFE::AddAndLambda::lambda_example --args 7u8


//# run 0xCAFE::AddAndLambda::call_inline_double --args 8u8


//# run 0xCAFE::AddAndLambda::match_flag --args 0u8


//# run 0xCAFE::AddAndLambda::match_flag --args 1u8


//# run 0xCAFE::AddAndLambda::match_flag --args 2u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::AddAndLambda;

    struct Wrapper has copy, drop, store {
        val: u8,
    }

    public fun test_nested_call(x: u8, y: u8): u8 {
        // Call add_and_return_result from AddAndLambda module
        let sum_added = AddAndLambda::add_and_return_result(x, y);
        // Call call_inline_double to double the sum_added
        AddAndLambda::call_inline_double(sum_added)
    }

    public fun test_use_custom_type() {
        let w = Wrapper { val: 42u8 };
        let _ = w;
    }
}



//# run 0xCAFE::CallerModule::test_nested_call --args 3u8 4u8


//# run 0xCAFE::CallerModule::test_use_custom_type
