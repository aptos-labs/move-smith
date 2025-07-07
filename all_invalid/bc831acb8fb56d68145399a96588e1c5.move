//# publish
module 0xCAFE::WildcardTest {
    use std::signer;

    struct WildcardResource has store, key {
        id: u64,
        data: vector<u8>,
    }

    public fun publish_resource(s: signer, id: u64, data: vector<u8>) {
        let res = WildcardResource { id, data };
        move_to<WildcardResource>(&s, res);
    }

    public fun modify_resource(s: signer, new_id: u64) {
        let r = borrow_global_mut<WildcardResource>(signer::address_of(&s));
        r.id = new_id;
    }

    public fun delete_resource(s: signer) {
        let r = move_from<WildcardResource>(signer::address_of(&s));
        let WildcardResource { id: _id, data: _data } = r;
    }
}

//# run 0xCAFE::WildcardTest::publish_resource --signers 0xA11CE --args 42u64 b"data"

//# run 0xCAFE::WildcardTest::modify_resource --signers 0xA11CE --args 100u64

//# run 0xCAFE::WildcardTest::delete_resource --signers 0xA11CE


// Compiler error for duplicate fields in a struct
// This intentionally triggers a compile error and will not be run

//# publish
module 0xCAFE::DuplicateFieldError {
    struct Duplicate has copy, drop, store {
        field: u8,
        field: u16,
    }
}

// Custom struct types with user-specified type parameters and ability modifiers

//# publish
module 0xCAFE::GenericStructs {
    struct Container<T> has store {
        value: T,
    }

    struct CopyableContainer<T> has copy, drop, store {
        val: T,
    }

    public fun create_container_u8(val: u8): Container<u8> {
        Container<u8> { value: val }
    }

    public fun create_copyable_container_u16(val: u16): CopyableContainer<u16> {
        CopyableContainer<u16> { val }
    }
}

//# run 0xCAFE::GenericStructs::create_container_u8 --args 255u8

//# run 0xCAFE::GenericStructs::create_copyable_container_u16 --args 65535u16

// Featurres:
// a09d929e2204df43285784ad08728860: Use the '*' wildcard to represent any resource at a specific address in access specifications.
// b0dd8d21d612fb9287d60cc5e8081c3a: Receive compiler errors when duplicate field names are given in a struct or resource definition.
// e48e7678a9e000f681c6801151e90943: Define custom struct types with user-specified type parameters and ability modifiers.
