//# publish
module 0xCAFE::AddressSpan {
    use std::vector;

    /// A struct representing a spanned address,
    /// with an address and dummy location info (start and end offsets).
    struct SpannedAddress has copy, drop, store {
        addr: address,
        start_offset: u64,
        end_offset: u64,
    }

    /// Public function to create a SpannedAddress from raw address and offsets.
    public fun create(addr: address, start_offset: u64, end_offset: u64): SpannedAddress {
        assert!(start_offset <= end_offset, 1001);
        SpannedAddress { addr, start_offset, end_offset }
    }

    /// Public getter for the address field.
    public fun address(spanned: &SpannedAddress): address {
        spanned.addr
    }

    /// Dummy function to test returning SpannedAddress.
    public fun spanned_demo(): SpannedAddress {
        let addr = @0x1234567890abcdef;
        create(addr, 5, 10)
    }
}

//# run 0xCAFE::AddressSpan::spanned_demo


//# publish
module 0xCAFE::TypeConstraints {
    /// Define a generic struct with a type parameter T that must have store ability.
    struct StoreOnly<T: store> has store {
        value: T
    }

    /// Define a generic struct with a type parameter T that must have copy + drop abilities.
    struct CopyDrop<T: copy+drop> has store {
        value: T
    }

    /// Define a generic struct with a type parameter T that must have key ability.
    struct Keyed<T: key> has key {
        val: T
    }

    /// Function returning a StoreOnly<u64> instance.
    public fun new_store_only(): StoreOnly<u64> {
        StoreOnly { value: 123u64 }
    }

    /// Function returning a CopyDrop<u8> instance.
    public fun new_copy_drop(): CopyDrop<u8> {
        CopyDrop { value: 42u8 }
    }

    /// Function accepting Keyed<address> and returning one field's address.
    public fun extract_key_val(key_obj: &Keyed<address>): address {
        key_obj.val
    }
}

//# run 0xCAFE::TypeConstraints::new_store_only

//# run 0xCAFE::TypeConstraints::new_copy_drop


//# run 0xCAFE::TypeConstraints::extract_key_val --args @0xCAFE


//# run
script {
    use 0xCAFE::AddressSpan;
    use 0xCAFE::TypeConstraints;

    fun main(): u8 {
        let spanned = AddressSpan::create(@0xCAFE, 0, 8);
        let _addr = AddressSpan::address(&spanned);

        let so = TypeConstraints::new_store_only();
        let cd = TypeConstraints::new_copy_drop();

        // Use extract_key_val with Keyed<address> - create a local Keyed value
        let key_obj = TypeConstraints::Keyed<address> { val: @0xBEEF };
        let extracted = TypeConstraints::extract_key_val(&key_obj);

        // Return the u8 value from CopyDrop struct
        cd.value
    }
}

// Featurres:
// 23a9348afd2bf228c638cc8855a47381: Return a spanned (location-aware) NumericalAddress for further use in code analysis or compilation.
// 19b3347fb09813cc821a900427f665c5: Define a single main function as the entry point in a script, and ensure the script is omitted if this function is filtered out.
// 184619619054074649b3e2fb51304916: Define type parameters with specific abilities and constraints in Move code.
