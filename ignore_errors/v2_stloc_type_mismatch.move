//# publish
module 0xCAFE::Module0 {
    public fun function0() {
        let x = &0u8;
        &mut (*(copy x));
    }
}
