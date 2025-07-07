
//# publish
module 0xDEAD::DeprecatedNamespace {
    // deprecated
    public fun deprecated_function(): bool {
        true
    }
}



//# publish
module 0xBEEF::AdvancedFeatures {

    // Use internal to restrict access
    struct InternalResource has store {
        value: u64,
    }

    // A simple resource with nested fields for testing dot notation
    struct InnerMostStruct has store {
        deep_value: u128,
    }
    struct NestedStruct has store {
        inner: InnerMostStruct,
        other_field: bool,
    }

    // A struct with multiple nested fields
    struct ComplexStruct has store {
        nested: NestedStruct,
        flag: bool,
    }

    // Initialize a resource with nested data
    public fun init_resource(account: &signer): () {
        let resource = InternalResource { value: 42 };
        move_to<InternalResource>(account, resource);
        // For nested structures
        let innermost = InnerMostStruct { deep_value: 999999u128 };
        let nested = NestedStruct { inner: innermost, other_field: true };
        let complex = ComplexStruct { nested: nested, flag: false };
        move_to<ComplexStruct>(account, complex);
    }

    // Function to access nested fields via dot notation
    public fun get_deep_value(c: &ComplexStruct): u128 {
        c.nested.inner.deep_value
    }

    // Function to access multiple nested fields in one expression
    public fun get_multiple_nested(c: &ComplexStruct): (bool, u128) {
        (c.nested.other_field, c.nested.inner.deep_value)
    }

    // Function to destructure a complex struct with variable shadowing
    public fun destructure_and_shadow(c: &mut ComplexStruct) {
        // Outer variable
        let flag = c.flag;
        // Inner shadowing
        let flag = c.nested.other_field;
        c.flag = flag;
    }

    // Function demonstrating specification pre/post conditions
    public fun check_invariant(c: &ComplexStruct): bool
        //@ ensures result == (c.nested.inner.deep_value > 500000u128)
    {
        c.nested.inner.deep_value > 500000u128
    }

    // Function to assert invariants; does not access global state
    public fun validate_invariant(c: &ComplexStruct): bool {
        // Standard invariant check
        let res = check_invariant(c);
        res
    }

    // Function with a local variable shadowing outer resource
    public fun variable_shadowing(account: &signer): u64 {
        let value = 100u64;
        if (true) {
            let value = 200u64; // shadowing
            value
        } else {
            value
        }
    }

    // Function to access internal resource (for testing internal visibility)
    public fun access_internal_resource(account: &signer): u64 acquires InternalResource {
        let resource_ref: &InternalResource = borrow_global<InternalResource>(account);
        resource_ref.value
    }

    // Function to mutate internal resource
    public fun mutate_internal_resource(account: &signer, new_value: u64) acquires InternalResource {
        let resource_mut: &mut InternalResource = borrow_global_mut<InternalResource>(account);
        resource_mut.value = new_value;
    }
}



//# run 0xBEEF::AdvancedFeatures::init_resource --signers 0xBAEE



//# run 0xBEEF::AdvancedFeatures::get_deep_value --args 0xBEEF



//# run 0xBEEF::AdvancedFeatures::get_multiple_nested --args 0xBEEF



//# run 0xBEEF::AdvancedFeatures::destructure_and_shadow --signers 0xBAEE



//# run 0xBEEF::AdvancedFeatures::validate_invariant --args 0xBEEF



//# run 0xBEEF::AdvancedFeatures::variable_shadowing --signers 0xBAEE



//# run 0xBEEF::AdvancedFeatures::access_internal_resource --signers 0xBAEE



//# run 0xBEEF::AdvancedFeatures::mutate_internal_resource --signers 0xBAEE --args 12345u64
