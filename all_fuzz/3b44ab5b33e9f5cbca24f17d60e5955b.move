
//# publish
module 0xCAFE::InlineModule {
    public fun add_two(a: u8, b: u8): u8 {
        a + b
    }

    public fun add_then_triple(a: u8, b: u8): u8 {
        let sum = add_two(a, b);
        sum * 3
    }
}



//# publish
module 0xCAFE::LambdaModule {
    use 0xCAFE::InlineModule;

    public fun apply_lambda(a: u8, b: u8): u8 {
        let lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            InlineModule::add_two(x, y)
        };
        lambda(a, b)
    }

    public fun nested_lambda_call(a: u8, b: u8): u8 {
        let outer_lambda: |u8, u8|u8 has copy+drop = |x: u8, y: u8| {
            let inner_lambda: |u8, u8|u8 has copy+drop = |m: u8, n: u8| {
                InlineModule::add_then_triple(m, n)
            };
            inner_lambda(x, y)
        };
        outer_lambda(a, b)
    }
}



//# run 0xCAFE::InlineModule::add_two --args 100u8 55u8



//# run 0xCAFE::InlineModule::add_then_triple --args 5u8 7u8



//# run 0xCAFE::LambdaModule::apply_lambda --args 33u8 44u8



//# run 0xCAFE::LambdaModule::nested_lambda_call --args 2u8 3u8
