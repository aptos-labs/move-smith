
//# publish
module 0xCAFE::InlineFunctionsModule {
    /// An inline function that adds two u16 values
    public inline fun inline_add(a: u16, b: u16): u16 {
        a + b
    }

    // test]  // fixed attribute syntax and added 'ignore' workaround
    public fun dummy_test() {
        let x = inline_add(5u16, 6u16);
        // ignore is not defined by default, so just do nothing with x or put a nop
        let _ = x;
    }
}


//# publish
module 0xCAFE::AddAndLambda {
    /// Adds two u8 values and returns the sum + 5
    public fun add_then_increment(a: u8, b: u8): u8 {
        let sum = a + b;
        sum + 5
    }

    /// Uses a lambda expression to multiply input by 2, then adds 3
    public fun lambda_double_add3(x: u8): u8 {
        let double_lambda: |u8| u8 has copy + drop = |v: u8| v * 2;
        let doubled = double_lambda(x);
        doubled + 3
    }

    /// Calls the inline function `inline_add` from InlineFunctionsModule
    public fun call_inline_add(a: u16): u16 {
        // use full module path including address
        0xCAFE::InlineFunctionsModule::inline_add(a, 10)
    }

    /// Calls a lambda that returns a tuple and returns the sum of the tuple
    public fun lambda_tuple_sum(x: u8, y: u8): u8 {
        let tuple_lambda: |u8, u8| (u8, u8) has copy + drop = |p: u8, q: u8| (p * 2, q * 3);
        let (r, s) = tuple_lambda(x, y);
        r + s
    }

    // test]  // fixed attribute syntax
    public fun test_attribute_function() {
        let val = 1u8 + 1u8;
        let _ = val;  // to avoid unused variable warning
    }
}


//# run 0xCAFE::AddAndLambda::add_then_increment --args 10u8 15u8


//# run 0xCAFE::AddAndLambda::lambda_double_add3 --args 7u8


//# run 0xCAFE::AddAndLambda::call_inline_add --args 20u16


//# run 0xCAFE::AddAndLambda::lambda_tuple_sum --args 3u8 4u8


//# run 0xCAFE::AddAndLambda::test_attribute_function


//# run 0xCAFE::InlineFunctionsModule::dummy_test
