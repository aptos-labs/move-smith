//# publish
module 0xCAFE::Module0 {
    const ADDR: address = @0xBEEF;
    struct S has copy, drop, store, key {}

    public fun f() acquires S {
        if (true)  { } else { borrow_global_mut<S>(ADDR); };
    }
}
