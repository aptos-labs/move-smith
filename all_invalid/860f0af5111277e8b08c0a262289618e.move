//# publish
module 0xCAFE::MyModule {
    public fun f1(x: u8, flag: bool): u64 {
        // simple implementation for test
        x as u64 + if (flag) { 1 } else { 0 }
    }
}
