
//# publish
module 0xDEAD::DeprecatedNamespace {
    // deprecated]
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
    public fun init_resource(account: &signer): InternalResource {
        let resource = InternalResource { value: 42 };
        move_to<InternalResource>(account, resource);
        // For nested structures
        let innermost = InnerMostStruct { deep_value: 999999u128 };
        let nested = NestedStruct { inner: innermost, other_field: true };
        let complex = ComplexStruct { nested: nested, flag: false };
        move_to<ComplexStruct>(account, complex);
        // Return resource for further validation if needed
        move_to<InternalResource>(account, resource)
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
        let resource_ref: &InternalResource = borrow_global<InternalResource>(signer::address_of(account));
        resource_ref.value
    }

    // Function to mutate internal resource
    public fun mutate_internal_resource(account: &signer, new_value: u64) acquires InternalResource {
        let resource_mut: &mut InternalResource = borrow_global_mut<InternalResource>(signer::address_of(account));
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


// Featurres:
// 78f8dc464195108ec06049bb15ab9fa2: Access nested fields of expressions using dot notation in Move code.
// c1367d37b2075aa6fdcc5740b3ac2c36: Attach deprecation attributes at the address (namespace) level to mark all modules under it as deprecated.
// 63d45d364eac9afd0006b4525c93f85c: Use 'internal' visibility to restrict access within the module or package.
// fdc6779e3d725d21cb1af960a124c0e2: Implement specification checking to ensure that specifications adhere to pureness and correctness standards.
// 5a8683e4815f33ccbf904d0d411d5c78: Test that variable shadowing with destructuring assignments in nested blocks works correctly and independently.
// a595322bcd6b0610dd5049bc4d6bea14: Avoid referencing or depending on global state (i.e., resources in storage) from inside struct invariant expressions.
