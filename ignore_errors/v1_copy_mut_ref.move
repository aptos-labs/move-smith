//# publish
module 0xCAFE::Module0 {
    public fun function2() {
        let x = &mut 0u8;
        (copy x == copy x);
    }
}
