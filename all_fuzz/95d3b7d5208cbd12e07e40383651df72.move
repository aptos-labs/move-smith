//# publish
module 0x1::TestModule {
    use std::vector;

    struct StructB has drop {
        a: u8,
        b: vector<u8>,
    }

    // test]
    fun test_structb_creation() {
        let v = vector::empty<u8>();
        let s = StructB { a: 42, b: v };
        assert!(s.a == 42, 1);
        assert!(vector::is_empty(&s.b), 2);
    }
}
