
//# publish
module 0xCAFE::InlineModule {
    public inline fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun call_inline_internally(x: u8): u8 {
        inline_increment(x)
    }
}


//# publish
module 0xCAFE::LambdaModule {
    use 0xCAFE::InlineModule;

    public fun call_lambda_and_inline(x: u8, y: u8): u8 {
        let lambda: |u8, u8| u8 has copy+drop = |a: u8, b: u8| {
            a * b
        };
        let product = lambda(x, y);
        // Call inline function from another module
        let incremented = InlineModule::inline_increment(product);
        incremented
    }

    // Fixed: change lambda type to || u8 (no arguments, no tuple)
    public fun call_lambda_no_args(): u8 {
        let lambda: || u8 has copy+drop = || {
            42u8
        };
        lambda()
    }
}


//# run 0xCAFE::LambdaModule::call_lambda_and_inline --args 3u8 7u8


//# run 0xCAFE::LambdaModule::call_lambda_no_args


//# run 0xCAFE::InlineModule::call_inline_internally --args 99u8
