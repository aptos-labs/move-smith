//# publish
module 0xCAFE::MyModule {
    public inline fun f2(a: u16): (u16, u16) {
        (a, a + 1)
    }
}
