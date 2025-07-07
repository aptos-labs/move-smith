
//# publish
module 0xCAFE::TestModule {
    const CONST_VALUE: u64 = 42;

    public fun add_two_u8_values(a: u8, b: u8): u8 {
        let sum = a + b;
        // Return fixed 99u8 regardless of sum, to test function compute then return specific value
        99u8
    }

    public fun call_lambda_and_return(a: u8, b: u8): (u8, u8) {
        let lambda: |u8, u8|(u8, u8) has copy+drop = |x: u8, y: u8| {
            let add = x + y;
            let mul = x * y;
            (add, mul)
        };
        lambda(a, b)
    }

    public inline fun inline_add(a: u8, b: u8): u8 {
        a + b
    }

    public fun call_inline_add_from_other_module(): u8 {
        0xCAFE::TestModule::inline_add(10, 32)
    }

    public fun return_constant_as_u64(): u64 {
        CONST_VALUE
    }

    public fun cond_skip_with_assert() {
        let x: u64 = 10;
        if (false) {
            let _new_x = x + 5;
        } else {
            // Assign to dummy variable to satisfy syntax, but avoid illegal `let _ = ()`.
            let _dummy = 0;
        };
        assert!(x == 10, 777);
    }
}


//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::TestModule;

    public fun nested_inline_call(): u8 {
        TestModule::call_inline_add_from_other_module()
    }

    public fun use_constant(): u64 {
        TestModule::return_constant_as_u64()
    }
}


//# run 0xCAFE::TestModule::add_two_u8_values --args 50u8 25u8


//# run 0xCAFE::TestModule::call_lambda_and_return --args 3u8 7u8


//# run 0xCAFE::TestModule::call_inline_add_from_other_module


//# run 0xCAFE::CallerModule::nested_inline_call


//# run 0xCAFE::CallerModule::use_constant


//# run 0xCAFE::TestModule::cond_skip_with_assert
