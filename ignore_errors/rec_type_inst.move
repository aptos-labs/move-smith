//# publish
module 0xCAFE::Module0 {
    struct HasCopyDrop has copy, drop {}

    struct C2<T1: drop, phantom T2: copy> has copy, drop, store {}

    fun m1<T1: copy+drop, T2: copy>(x: T1) {
        m2<C2<HasCopyDrop, T2>, HasCopyDrop>(C2{});
    }
    fun m2<T3: copy+drop, T4: copy>(x: T3): T3 {
        m1<T3, T4>(x);
        x
    }
}
