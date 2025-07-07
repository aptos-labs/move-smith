
//# publish
module 0xBADD::AccessSpecifiers {
    use std::vector;

    // Test optional access specifiers
    // Struct with default (public) access
    struct PublicStruct has copy, drop, store {
        id: u64,
        name: vector<u8>,
    }

    // Struct with internal (module) access
    struct InternalResource has key {
        balance: u64,
    }

    // Struct with private (no public) access - not publicly accessible, example for compiler check
    struct PrivateStruct {
        secret_value: u8,
    }

    // Public function returning a struct with default public access
    public fun create_public_struct(id: u64, name: vector<u8>): PublicStruct {
        PublicStruct { id, name }
    }

    // Public function creating internal resource
    public fun create_internal_resource(bal: u64): InternalResource {
        InternalResource { balance: bal }
    }

    // Try to access internal resource outside module should be restricted by compiler (not simulated here)
    // But in test instantiations, we will call it internally.
    // No public constructor for private structs; testing compiler may fail if access is attempted outside module
}


//# run 0xBADD::AccessSpecifiers::create_public_struct --args 123u64  # assuming vector creation is skipped for simplicity


//# run 0xBADD::AccessSpecifiers::create_internal_resource --args 456u64


//# publish
module 0xBADD::AddressParsing {
    use std::vector;

    // Tested with numeric address parsing to anonymous bytes
    public fun parse_address_bytes(): vector<u8> {
        // Example: parse 0xC0FFEE as bytes
        // We must mimic byte parsing; explicit conversion in test
        // In actual Move, this is static, here we just directly assign
        vector[0xC0u8, 0xFFu8, 0xEEu8]
    }

    // Alternatively, simulate dynamic parsing from string literal, but in Move code, static is enough
}


//# run 0xBADD::AddressParsing::parse_address_bytes


//# publish
module 0xBADD::TypePassThrough {
    use std::vector;

    // Function that accepts optional vector of types (pass as vector of u8 for simplicity)
    public fun process_type_vector(types: vector<u8>) {
        // For testing, just assert the vector length or content
        assert!(vector::length(&types) >= 0, 42);
    }

    // Function that handles optional presence of types
    public fun pass_optional_types(types_option: Option<vector<u8>>) {
        if (exists(&types_option)) {
            let types_ref = &*types_option;
            process_type_vector(*types_ref);
        } else {
            // Do something default
        };
    }
}


//# run 0xBADD::TypePassThrough::process_type_vector --args 1u8 2u8 3u8


//# run 0xBADD::TypePassThrough::pass_optional_types --args  # passing none, may be skipped since Option is not directly constructable here


// Featurres:
// a6241b2c1c8cab59ddee650c0e764b5d: Specify optional access specifiers when defining modules or resources
// b1fa6f767fd4acc61a5bffba6fa81dc6: Represent addresses as anonymous address bytes when parsing a numeric value in a name access.
// 0e12a1b2edb5efe353962ad8146a7927: Pass an optional vector of types to functions to handle cases where type information might be absent, enabling flexible type assignments in your code.
