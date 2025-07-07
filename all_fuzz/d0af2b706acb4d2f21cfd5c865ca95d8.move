//# publish
module 0x1::TestModule {
    public inline fun f2(a: u16): (u16, u16) {
        (a + 1, a + 2)
    }
    
    public fun call_inline_function(a: u16): u16 {
        let (p, q) = Self::f2(a);
        p + q
    }
}
