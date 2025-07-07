//# publish
module 0xCAFE::TestSpecAndVariants {
    use std::signer;

    // Define resource struct with key ability
    struct Container has key {
        value: u64,
    }

    // Define struct variants with positional fields using parentheses ( ... )
    // Note: Move does not officially support struct variants syntax in the same way as enums,
    // but enum variants with named or positional fields work.
    // We'll define an enum with positional fields variants to simulate this.
    enum VariantEnum has copy, drop {
        Unit,
        Positional(u8, u8),
        Named { a: u8, b: u8 },
    }

    // Distinct module members
    const CONST_VAL: u8 = 42;

    // Public variable (simulated by resource)
    struct Storage has key {
        stored: u8,
    }

    // Public function
    public fun store_value(s: signer, v: u8) {
        let address = signer::address_of(&s);
        let storage = Storage {stored: v};
        move_to<Storage>(&s, storage);
    }

    public fun get_stored_value(addr: address): u8 {
        let storage_ref = borrow_global<Storage>(addr);
        storage_ref.stored
    }

    // Public inline function returning tuple
    public inline fun tuple_returner(): (u8, u8) {
        (1u8, 2u8)
    }

    // Public function returning enum variant with positional fields
    public fun variant_with_positional(): VariantEnum {
        VariantEnum::Positional(5u8, 10u8)
    }

    // Spec function with return type specified after colon
    spec fun spec_func(): u64 {
        1234u64
    }

    // Spec function returning tuple with explicit type
    spec fun spec_tuple(): (u8, u8) {
        (CONST_VAL, 7u8)
    }

    // spec function returning enum variant
    spec fun spec_variant(): VariantEnum {
        VariantEnum::Unit
    }
}

//# run
script {
    use std::signer;
    use 0xCAFE::TestSpecAndVariants;

    fun main(s: signer) {
        TestSpecAndVariants::store_value(&s, 99u8);
        let addr = signer::address_of(&s);
        let _val = TestSpecAndVariants::get_stored_value(addr);

        let (a, b) = TestSpecAndVariants::tuple_returner();
        let _variant = TestSpecAndVariants::variant_with_positional();

        // invoke spec functions indirectly to ensure coverage (no runtime effect)
        let _spec_val: u64 = TestSpecAndVariants::spec_func();
        let (_x, _y) = TestSpecAndVariants::spec_tuple();
        let _enum_unit = TestSpecAndVariants::spec_variant();
    }
}

// Featurres:
// ba65b0a21cd5b5515b25dcf742939b68: Specify the return type of a spec function after a colon.
// 38c9b5c668830d116f1ace86df64486f: Declare distinct kinds of module members in a Move module.
// 4abf595f2f691afdfae6c6864cf9db49: Define struct variants with positional fields using parentheses (( ... ))
