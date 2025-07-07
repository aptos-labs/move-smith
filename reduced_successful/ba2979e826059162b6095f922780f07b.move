
//# publish
module 0xCAFE::CalcModule {
    // Module to test addition and inline function returning tuples
    public fun add_and_return_special(x: u8, y: u8): u8 {
        let sum = x + y;
        if (sum > 10) {
            42u8
        } else {
            sum
        }
    }

    public fun make_lambda_and_call(x: u8, y: u8): (u8, u8) {
        let lambda: |u8, u8| (u8, u8) has copy + drop = |a: u8, b: u8| {
            (a + b, a * b)
        };
        lambda(x, y)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}




//# publish
module 0xCAFE::UseInlineModule {
    use 0xCAFE::CalcModule;

    public fun call_inline_and_add(x: u8, y: u8): u8 {
        let s = CalcModule::inline_add(x, y);
        CalcModule::add_and_return_special(s, 1u8)
    }
}




//# publish
module 0xCAFE::LoopTestModule {
    // Tests nonterminating loops with nested breaks and failing assertion
    public fun complicated_loop(x: u8) {
        let val = x;
        loop {
            val = val + 1u8;
            loop {
                if (val % 3u8 == 0u8) {
                    break;
                };
                break;
            };
            if (val > 100u8) {
                break;
            };
        };

        // This will fail if val is not > 100
        assert!(val > 100u8, 777);
    }
}




//# run 0xCAFE::CalcModule::add_and_return_special --args 4u8 3u8




//# run 0xCAFE::CalcModule::make_lambda_and_call --args 5u8 6u8




//# run 0xCAFE::UseInlineModule::call_inline_and_add --args 4u8 3u8




//# run 0xCAFE::LoopTestModule::complicated_loop --args 48u8
