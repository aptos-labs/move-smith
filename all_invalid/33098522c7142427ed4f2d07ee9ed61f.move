//# publish
module 0xCAFE::TestSpecAndVariants {
    use std::signer;

    // Define resource struct with key ability
    struct Container has key {
        value: u64,
    }

    // Enum with positional and named fields variants
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
        let _address = signer::address_of(&s); // prefix with _ to avoid warning
        let storage = Storage { stored: v };
        move_to<Storage>(s, storage);  // pass signer by value, not reference
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

    // Spec functions need to be marked `spec` and are not callable at runtime.
    // We remove calls to spec functions from runtime code.
    spec fun spec_func(): u64 {
        1234u64
    }

    spec fun spec_tuple(): (u8, u8) {
        (CONST_VAL, 7u8)
    }

    spec fun spec_variant(): VariantEnum {
        VariantEnum::Unit
    }
}

//# run
script {
    use std::signer;
    use 0xCAFE::TestSpecAndVariants;

    fun main(s: signer) {
        TestSpecAndVariants::store_value(s, 99u8);  // pass signer by value

        let addr = signer::address_of(&s);
        let _val = TestSpecAndVariants::get_stored_value(addr);

        let (a, b) = TestSpecAndVariants::tuple_returner();
        let _variant = TestSpecAndVariants::variant_with_positional();

        // Removed calls to spec functions because they do not exist at runtime
        // Spec functions are for verification/specification only and cannot be called here
    }
}