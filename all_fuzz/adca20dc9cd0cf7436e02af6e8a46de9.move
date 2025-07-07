
//# publish
module 0xCAFE::LambdaModule {
    public fun simple_addition(a: u8, b: u8): u8 {
        a + b
    }

    public fun lambda_addition(): u8 {
        let add: |u8, u8| u8 has copy + drop = |x: u8, y: u8| {
            x + y
        };
        add(7u8, 8u8)
    }

    public fun nested_lambda(): u8 {
        let outer: |u8| u8 has copy + drop = |x: u8| {
            let inner: |u8| u8 has copy + drop = |y: u8| { x + y };
            inner(10u8)
        };
        outer(5u8)
    }
}



//# run 0xCAFE::LambdaModule::simple_addition --args 10u8 20u8



//# run 0xCAFE::LambdaModule::lambda_addition



//# run 0xCAFE::LambdaModule::nested_lambda


// # publish
//# publish
module 0xCAFE::InlineCaller {
    use 0xCAFE::LambdaModule;

    // Removed `inline` keyword since `inline fun` cannot be called as normal functions by other modules unless both are inline or exposed properly.
    public fun call_inline_add(x: u8, y: u8): u8 {
        LambdaModule::simple_addition(x, y)
    }

    public fun call_nested_lambda_add(): u8 {
        LambdaModule::lambda_addition()
    }
}



//# run 0xCAFE::InlineCaller::call_inline_add --args 15u8 25u8



//# run 0xCAFE::InlineCaller::call_nested_lambda_add
