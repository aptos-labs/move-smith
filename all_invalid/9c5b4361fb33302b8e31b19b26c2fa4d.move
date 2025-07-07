
//# publish
module 0xCAFE::AbilitiesInParams {
    // Test that function parameters can specify abilities such as `has drop`
    // directly in their type annotation and still accept values matching the base type

    struct DropType has drop {
        value: u8
    }

    struct KeyType has key {
        id: u64
    }

    struct StoreType has store {
        count: u64
    }

    // Public function specifying `has drop` in parameter type annotation.
    // This should accept DropType which has drop.
    public fun accept_drop_param(x: DropType): u8 {
        x.value
    }

    // Public function specifying `has key` in parameter type annotation.
    // This should accept KeyType which has key.
    public fun accept_key_param(x: KeyType): u64 {
        x.id
    }

    // Public function specifying `has store` in parameter type annotation.
    // This should accept StoreType which has store.
    public fun accept_store_param(x: StoreType): u64 {
        x.count
    }

    // Function taking DropType but without ability specifier in arg type for comparison
    public fun accept_drop_plain(x: DropType): u8 {
        x.value
    }

    // Function that constructs DropType and calls accept_drop_param
    public fun run_drop() {
        let d = DropType {value: 10};
        let x = accept_drop_param(d);
        let y = accept_drop_plain(d);
        let _ = x + y;
    }
}



//# run 0xCAFE::AbilitiesInParams::run_drop



//# publish
module 0xCAFE::OptionalAccess {
    use std::signer;

    // Resource without explicit access specifier (implicit private)
    struct PrivateRes has store {
        val: u64
    }

    // Public resource 
    public struct PublicRes has store, key {
        val: u64
    }

    // Public function to create PrivateRes under the signer's account
    public fun create_private_res(s: signer, val: u64) {
        let res = PrivateRes { val };
        move_to(&s, res);
    }

    // Public function to create PublicRes under the signer's account
    public fun create_public_res(s: signer, val: u64) {
        let res = PublicRes { val };
        move_to(&s, res);
    }

    // Public function to borrow PrivateRes reference (within same module allowed)
    public fun borrow_private(s: signer): &PrivateRes {
        borrow_global<PrivateRes>(signer::address_of(&s))
    }

    // Public function to borrow PublicRes reference
    public fun borrow_public(s: signer): &PublicRes {
        borrow_global<PublicRes>(signer::address_of(&s))
    }
}



//# run 0xCAFE::OptionalAccess::create_private_res --signers 0xABCD --args 123u64



//# run 0xCAFE::OptionalAccess::borrow_private --signers 0xABCD



//# run 0xCAFE::OptionalAccess::create_public_res --signers 0xABCD --args 456u64



//# run 0xCAFE::OptionalAccess::borrow_public --signers 0xABCD




//# publish
module 0xCAFE::TypeParamsTest {
    // Define a generic struct using type parameters T0, T1, T2
    struct TripleHolder<T0, T1, T2> has copy, drop, store {
        field0: T0,
        field1: T1,
        field2: T2
    }

    // Generic function returns a tuple of the type parameters packed in TripleHolder
    public fun create_triple<T0: copy, T1: copy, T2: copy>(a: T0, b: T1, c: T2): (TripleHolder<T0, T1, T2>, u8) {
        let t = TripleHolder<T0, T1, T2> {
            field0: a,
            field1: b,
            field2: c
        };
        (t, 99u8)
    }

    // Runner function to test create_triple and type parameter names
    public fun test_triples() {
        let (triple1, n) = create_triple<u8, u16, bool>(10u8, 20u16, true);
        let _ = triple1.field0;
        let _ = triple1.field1;
        let _f: bool = triple1.field2;
        let _ = n;
    }
}



//# run 0xCAFE::TypeParamsTest::test_triples
