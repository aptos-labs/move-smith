
//# publish
module 0xCAFE::LambdaModule {
    public fun add_and_return_fixed(a: u8, b: u8): u8 {
        let sum = a + b;

        let lambda: |u8| u8 has copy+drop = |x: u8| {
            x + 1
        };

        if (sum > 10) {
            lambda(sum)
        } else {
            0
        }
    }

    public fun with_lambda_expr(x: u8, y: u8): u8 {
        let f: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            let c = a + b;
            c * 2
        };
        f(x, y)
    }

    // Change `public inline fun` to just `public fun`, because Aptos Move does not support `inline` functions in this form
    public fun inline_add(a: u8, b: u8): u8 {
        a + b
    }
}



//# run 0xCAFE::LambdaModule::add_and_return_fixed --args 6u8 6u8



//# run 0xCAFE::LambdaModule::with_lambda_expr --args 4u8 3u8



//# run 0xCAFE::LambdaModule::inline_add --args 10u8 20u8



//# publish
module 0xCAFE::CallerModule {
    use 0xCAFE::LambdaModule;

    public fun call_inline_and_add(a: u8, b: u8): u8 {
        let sum = LambdaModule::inline_add(a, b);
        sum + 5
    }

    public fun nested_lambda(x: u8, y: u8): u8 {
        let lambda_outer: |u8| u8 has copy+drop = |z: u8| {
            LambdaModule::inline_add(z, 10u8)
        };
        let lambda_inner: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            lambda_outer(a + b)
        };
        lambda_inner(x, y)
    }
}



//# run 0xCAFE::CallerModule::call_inline_and_add --args 5u8 7u8



//# run 0xCAFE::CallerModule::nested_lambda --args 4u8 6u8
