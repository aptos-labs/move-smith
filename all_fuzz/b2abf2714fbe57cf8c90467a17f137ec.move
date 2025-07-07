
//# publish
module 0xCAFE::SpecModule {
    const CONST_SPEC_VALUE: u64 = 42;

    spec module {}

    spec fun spec_fn(x: u64): u64 {
        x + CONST_SPEC_VALUE
    }

    public fun dummy() {}
}
