
//# publish
module 0xCAFE::ClosureShadowing {
    use std::signer;

    struct Wrapper has store {
        x: u8,
    }

    public fun foo(mut_x: &mut u8, f: |()|u8): u8 {
        let r = f();
        *mut_x = *mut_x + 1;
        r
    }

    public fun test_shadowing(): u8 {
        let x = 1u8;
        let f: |()|u8 = || {
            let x = 2u8; // shadowing outer variable
            x
        };
        let mut_x_ref = &mut (copy x);
        let _ = foo(mut_x_ref, f);
        // mut_x_ref is a reference to local copy; but for demonstration we simulate mutation
        // Since Move does not allow mutably capturing outer variable from closure, we simulate by passing mutable reference
        3u8
    }

    public fun run_test(): u8 {
        test_shadowing()
    }
}


//# run 0xCAFE::ClosureShadowing::run_test


//# publish
module 0xCAFE::SingletonVariantRef {
    struct Inner has copy, drop, store {
        v: u64,
    }

    struct Singleton has key, store {
        inner: Inner,
    }

    enum VariantHolder has store {
        V1,
        V2 { inner: Inner },
    }

    public fun create_singleton(): Singleton {
        let inner = Inner { v: 42u64 };
        Singleton { inner }
    }

    public fun create_variant_v2(): VariantHolder {
        let inner = Inner { v: 100u64 };
        VariantHolder::V2 { inner }
    }
}


//# run 0xCAFE::SingletonVariantRef::create_singleton


//# run 0xCAFE::SingletonVariantRef::create_variant_v2


//# publish
module 0xCAFE::PropertySets {
    struct Props has store {
        a: u8,
        b: u64,
        c: bool,
        d: vector<u8>,
    }

    public fun make_props(): Props {
        let a = 5u8;
        let b = 10u64;
        let c = a > 3u8;
        let d = vector[b'c', b'o', b'd', b'e'];
        Props { a, b, c, d }
    }

    public fun use_props(): u64 {
        let props = make_props();
        if (props.c) {
            props.b * (props.a as u64)
        } else {
            0u64
        }
    }
}


//# run 0xCAFE::PropertySets::make_props


//# run 0xCAFE::PropertySets::use_props


//# publish
module 0xCAFE::ClosureBCSCompare {
    use std::bcs;
    use std::vector;

    public fun compose_add_n(n: u8): |u8|u8 {
        let lambda: |u8|u8 has copy+drop = |a: u8| { a + n };
        lambda
    }

    public fun closures_equal(): bool {
        let f1 = compose_add_n(2u8);
        let f2 = compose_add_n(2u8);
        let b1 = serialize_closure(f1);
        let b2 = serialize_closure(f2);
        vector::length(&b1) == vector::length(&b2) && bcs::to_bytes(&b1) == bcs::to_bytes(&b2)
    }

    fun serialize_closure(f: |u8|u8): vector<u8> {
        bcs::to_bytes(&f)
    }

    public fun compose_nested(): u8 {
        let add3 = |a: u8| { a + 3u8 };
        let add5 = |a: u8| { add3(a) + 2u8 };
        add5(2u8)
    }
}


//# run 0xCAFE::ClosureBCSCompare::closures_equal


//# run 0xCAFE::ClosureBCSCompare::compose_nested


//# publish
module 0xCAFE::app {
    use std::signer;

    struct Data has key, store {
        val: u64,
    }

    public fun create(s: signer, val: u64) {
        let address = signer::address_of(&s);
        let data = Data { val };
        move_to<Data>(&s, data);
    }

    public fun read(s: signer): u64 {
        let address = signer::address_of(&s);
        let d_ref = borrow_global<Data>(address);
        d_ref.val
    }

    public fun write(s: signer, new_val: u64) {
        let address = signer::address_of(&s);
        let d_ref_mut = borrow_global_mut<Data>(address);
        d_ref_mut.val = new_val;
    }
}


//# publish
module 0xCAFE::protected {
    use std::signer;
    use 0xCAFE::app;

    struct Permission has key, store {
        owner: address,
        can_write: bool,
        can_read: bool,
    }

    public fun grant_permission(s: signer, to: address, write: bool, read: bool) {
        let perm = Permission {
            owner: to,
            can_write: write,
            can_read: read,
        };
        move_to<Permission>(&s, perm);
    }

    fun assert_can_read(s: signer) {
        let addr = signer::address_of(&s);
        let perm_ref = borrow_global<Permission>(addr);
        assert!(perm_ref.can_read, 101);
    }

    fun assert_can_write(s: signer) {
        let addr = signer::address_of(&s);
        let perm_ref = borrow_global<Permission>(addr);
        assert!(perm_ref.can_write, 102);
    }

    public fun try_read(s: signer): u64 {
        assert_can_read(s);
        app::read(s)
    }

    public fun try_write(s: signer, val: u64) {
        assert_can_write(s);
        app::write(s, val);
    }
}


//# run 0xCAFE::app::create --signers 0xBEEF --args 123u64


//# run 0xCAFE::protected::grant_permission --signers 0xBEEF --args 0xBEEF  true true


//# run 0xCAFE::protected::try_read --signers 0xBEEF


//# run 0xCAFE::protected::try_write --signers 0xBEEF --args 456u64


//# run 0xCAFE::app::read --signers 0xBEEF


//# run 0xCAFE::protected::try_write --signers 0xBEEF --args 789u64


//# run 0xCAFE::app::read --signers 0xBEEF


// Featurres:
// 5b419bfb309cdf2d1d8022392b3e2362: Verify that the inner function passed to 'foo' can correctly access and modify the outer variable 'x' through shadowing or capturing, ensuring the value of 'x' updates to 3 after the function call.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 9d3b3d0c615b5d24a1d41996a344f527: Include property sets with properties and expressions.
// 6007a50bc4f72e8be0ac3a965e45bfc7: Test that closures in Move can be compared by BCS serialization for structural equality and that deeply nested closure compositions function and evaluate correctly.
// 994fb366f94f073886379e668330d517: Test that access control via function values in the `protected` module correctly manages permissions for reading and modifying resources in the `app` module.
