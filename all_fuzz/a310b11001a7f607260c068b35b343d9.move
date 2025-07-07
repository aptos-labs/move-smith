//# publish
module 0xCAFE::LambdaModule {
    public fun test_lambda(): (u8, u8) {
        let lambda = |a: u8, b: u8| {
            let s = a + b;
            let p = a * b;
            (s, p)
        };
        lambda(3u8, 5u8)
    }
}
