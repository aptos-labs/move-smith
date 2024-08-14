//# publish
module 0xCAFE::Module0 {
    public fun function6(x: bool) {
        let y = &x;
        y = copy y;
        x = true;
        copy x;
    }
}
