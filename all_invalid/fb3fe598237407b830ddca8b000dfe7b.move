//# publish
module 0xCAFE::AttrTest {
    use std::signer;

    #[test]
    struct CopyableStruct has copy, drop, store {
        val: u8,
    }

    #[test = 42]
    struct StructWithAttr has copyable, store {
        x: u16,
    }

    #[copyable]
    struct CopyableUnit has copyable {}

    // Function parameter with abilities in type annotation
    public fun consume_copyable_with_drop(s: CopyableStruct has drop) {
        let _val = s.val;
    }

    public fun consume_copyable(s: CopyableStruct) {
        let _val = s.val;
    }

    public fun consume_struct_with_attr(s: StructWithAttr) {
        let _ = s.x;
    }

    public fun check_unit(_c: CopyableUnit) {}

    public fun call_all() {
        let s1 = CopyableStruct { val: 10 };
        consume_copyable_with_drop(s1);

        let s2 = StructWithAttr { x: 100 };
        consume_struct_with_attr(s2);

        let u = CopyableUnit {};
        check_unit(u);
    }
}

//# run 0xCAFE::AttrTest::call_all

// Featurres:
// ae06d7d0c8306a1b283bb349ffe7aaae: Use attribute annotations with optional associated values.
// eb61d58394c0d3888fa37794844b7def: Ensure 'copyable' attribute is properly formatted as ': copyable'.
// 0f396254db82fbef77ab3f222045a6e5: Test that function parameters can specify abilities such as `has drop` directly in their type annotations and still accept values matching the base type.
