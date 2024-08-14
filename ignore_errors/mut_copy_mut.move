//# publish
module 0xCAFE::Module0 {
    public fun function2(var4: u8): bool {
        (&mut (var4) != &mut (copy var4))
    }
}
