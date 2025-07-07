
//# publish
module 0xCAFE::AddAndReturn {
    public fun add_and_check(a: u8, b: u8): u8 {
        let sum = a + b;
        if (sum > 10) {
            42u8
        } else {
            0u8
        }
    }

    public fun lambda_double(x: u8): u8 {
        let double_fn: |u8|u8 has copy+drop = |v: u8| {
            v * 2
        };
        double_fn(x)
    }

    public fun lambda_add_and_double(a: u8, b: u8): u8 {
        let add_fn: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            x + y
        };
        let sum = add_fn(a, b);
        let double_fn: |u8|u8 has copy+drop = |z: u8| {
            z * 2
        };
        double_fn(sum)
    }

    // Added missing inline function here, so other modules can call it.
    public inline fun inline_wrapper(x: u16): (u16, u16) {
        (x + 5, x + 10)
    }
}



//# run 0xCAFE::AddAndReturn::add_and_check --args 5u8 10u8



//# run 0xCAFE::AddAndReturn::lambda_double --args 7u8



//# run 0xCAFE::AddAndReturn::lambda_add_and_double --args 3u8 4u8



//# publish
module 0xCAFE::Caller {
    use 0xCAFE::AddAndReturn;

    public fun call_inline_fun(a: u16): u16 {
        let (one, two) = AddAndReturn::inline_wrapper(a);
        one + two
    }

    public fun call_nested_inline(x: u16): u32 {
        let result = call_inline_fun(x);
        (result as u32) * 2
    }
}



//# run 0xCAFE::Caller::call_nested_inline --args 10u16



//# run 0xCAFE::Caller::call_inline_fun --args 8u16
