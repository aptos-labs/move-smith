//# publish
module 0xCAFE::AbilityTest {
    // This struct has copy, drop, store, key abilities
    struct S has copy, drop, store, key {
        x: u8,
    }

    // This struct has only store ability (no copy, no drop)
    struct NoCopyDrop has store, key {
        x: u8,
    }

    // Function with ability constraint: T must have copy ability
    public fun require_copy<T: copy>(_v: T) {}

    // Function with ability constraint: T must NOT have copy ability - Move does not support negative constraints,
    // so test that NoCopyDrop cannot be passed to require_copy.
    // We test by trying to call require_copy with both structs.

    // Runner function to test ability constraints
    public fun runner() {
        let a = S { x: 10 };
        require_copy<S>(a);

        // The following line, if uncommented, would cause compilation error:
        // let b = NoCopyDrop { x: 20 };
        // require_copy<NoCopyDrop>(b);

        // So here we only test that require_copy<S> works since S has copy ability.
    }
}
//# run 0xCAFE::AbilityTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::ShiftTest {
    // Test left shift and right shift on u8 constants, including shifts >= 8 bits.

    public fun runner() {
        // Left shift by 0 bits
        let l0 = (1u8 << 0);
        // Left shift by 7 bits (max within same u8)
        let l7 = (1u8 << 7);
        // Left shift by 8 bits (equal to bit width), should produce 0
        let l8 = (1u8 << 8);

        // Right shift by 0 bits
        let r0 = (128u8 >> 0);
        // Right shift by 7 bits (max within u8)
        let r7 = (128u8 >> 7);
        // Right shift by 8 bits (equal to bit width), should produce 0
        let r8 = (128u8 >> 8);

        // Use variables to prevent "unused variable" warnings
        let _ = (l0, l7, l8, r0, r7, r8);
    }
}
//# run 0xCAFE::ShiftTest::runner --signers 0xCAFE

//# publish
module 0xCAFE::TypeParamFieldTest {
    // Struct with type parameter used in a field
    struct Container<T> has store, key {
        val: T,
    }

    // Nested struct to test type parameters in nested structs
    struct NestedContainer<X, Y> has store, key {
        first: Container<X>,
        second: Y,
    }

    public fun runner() {
        let c = Container<u64> { val: 123 };
        let n = NestedContainer<u64, bool> { first: c, second: true };

        // unpack to test usage
        let Container { val } = n.first;
        let b = n.second;

        let _ = (val, b);
    }
}
//# run 0xCAFE::TypeParamFieldTest::runner --signers 0xCAFE

//# run
script {
    fun main() {
        // Just a no-op script to exercise script compilation and VM
    }
}


// Featurres:
// a7d9e02846f38d0861a9526f153978f9: Check for ability constraints in the function signature to enforce type capabilities in your Move code.
// d6f1856345e9323c4256bcaff78ef69a: Test that left and right shift operations on u8 constants correctly handle shifts greater than or equal to the bit width and produce valid constant values.
// 0e1bfda593452dc7ece2e48a51b11e61: Identify type parameters used in struct fields.
