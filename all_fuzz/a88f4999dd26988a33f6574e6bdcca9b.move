//# publish
module 0x1::TestModule {
    public fun apply_lambda(x: u8): u8 {
        let v1 = x * 2;
        let v2 = v1 + 1;
        v2
    }
}
