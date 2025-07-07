//# publish
module 0xCAFE::AdvancedTest {
    use std::signer;

    // Empty struct with no fields
    struct Empty has copy, drop, store, key {}

    // Enum with empty struct variant
    enum ComplexEnum has copy, drop {
        EmptyVariant,
        DataVariant {
            data: u64
        }
    }

    // Store an Empty struct at signer's address
    public fun store_empty(s: signer) {
        let e = Empty {};
        move_to<Empty>(&s, e);
    }

    // Remove Empty struct from signer's address
    public fun remove_empty(s: signer) {
        let e = move_from<Empty>(signer::address_of(&s));
        let Empty {} = e;
    }

    // Function with precondition and postcondition using requires and ensures
    // Requires input x > 0 and ensures returned value > x
    public fun requires_ensures(x: u64): u64
        requires x > 0
        ensures result > x
    {
        let y = x + 1;
        y
    }

    public fun test_requires_ensures_runner() {
        let _ = requires_ensures(1);
    }
}

//# run 0xCAFE::AdvancedTest::store_empty --signers 0xBABE

//# run 0xCAFE::AdvancedTest::remove_empty --signers 0xBABE

//# run 0xCAFE::AdvancedTest::test_requires_ensures_runner

// Featurres:
// a1012bc33bd28958397f5112b643c7cf: Create empty struct variants with no fields.
// df10cfb48ff6d4d43dd25ddb8db9e759: Use 'ensures' and 'requires' conditions to specify postconditions and preconditions for functions.
// 4a605b4da4cb9f0458b0e2a70aa9f3d1: Abort compilation if bytecode verification errors are found.
