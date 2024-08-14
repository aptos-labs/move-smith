//# publish
module 0xCAFE::Module0 {
    public fun f() {
        let x = 0u8;
        if (x == x) {} else { x = x; };
        x;
    }
}
