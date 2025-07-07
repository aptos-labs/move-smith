//# publish
module 0xCAFE::GenericTestModule {
    // Use std vector and other standard features
    use std::vector;

    // Define a generic struct with nested generic types
    struct Container<T> has copy, drop, store {
        value: T,
        nested: vector<T>,
    }

    // Define a nested struct with a generic type
    struct Nested<T> has copy, drop, store {
        inner: Container<T>,
        label: vector<u8>,
    }

    // Valid function: creates and initializes generic container with int type
    public fun create_container_int(): Container<u64> {
        let vec_u64 = vector::empty<u64>();
        vector::push_back(&mut vec_u64, 42);
        let c = Container {value: 100, nested: vec_u64};
        c
    }

    // Valid function: creates nested generic structs
    public fun create_nested_container(): Nested<bool> {
        let inner_vec = vector::empty<bool>();
        vector::push_back(&mut inner_vec, true);
        let inner_container = Container {value: 1u8, nested: inner_vec};
        let nested_struct = Nested {inner: inner_container, label: b"label"};
        nested_struct
    }

    // Intentionally invalid code: mismatched type argument (string instead of u8)
    // This should trigger a diagnostic error during compilation
    public fun invalid_type_mismatch() {
        let wrong_vec: vector<u8> = vector::empty<u8>();
        // Attempt to instantiate container with an invalid type parameter (string)
        let _ = Container<string> { value: "hello", nested: wrong_vec }; 
        
//# invalid_type
    }

    // Invalid nested access: trying to access a non-existent nested module or field
    // Should generate a diagnostic error for unresolved name
    public fun invalid_nested_access() {
        // Attempting to access a non-existent nested struct or module
        let _ = OuterModule::NonExistentStruct { field: 0 }; 
        
//# unresolved_name
    }

    // Function with resolution of nested modules and types, valid
    public fun nested_name_resolution(): vector<u8> {
        // Chain module and type resolution
        let label_bytes = 0xCAFE::GenericTestModule::Nested<u8>::label;
        label_bytes
    }

    // Function with an invalid nested name: referring to a non-existent nested type within a generic
    public fun invalid_nested_generic_access<T>(): T {
        // Trying to access an invalid nested module/type chain
        let _ = 0xCAFE::GenericTestModule::NonExistentGeneric::<T>::inner; 
        
//# unresolved_name
        // Return a default value for compilation
        // Since code won't compile due to the error above, just add an unreachable
        // to satisfy the return type
        // Note: Move requires explicit return. We can just return a dummy since code won't compile anyway.
        0u8
    }

    // Function testing nested generic access in combination with valid types
    public fun combined_generic_nested_access(): Container<Container<bool>> {
        let inner_vec = vector::empty<bool>();
        vector::push_back(&mut inner_vec, false);
        let inner_container = Container {value: true, nested: inner_vec};
        let outer_container = Container {value: 3u64, nested: vector::empty<u64>()};
        // Compose nested container
        outer_container
    }
}


//# run 0xCAFE::GenericTestModule::create_container_int

//# run 0xCAFE::GenericTestModule::create_nested_container

//# run 0xCAFE::GenericTestModule::invalid_type_mismatch

//# run 0xCAFE::GenericTestModule::invalid_nested_access

//# run 0xCAFE::GenericTestModule::nested_name_resolution

//# run 0xCAFE::GenericTestModule::invalid_nested_generic_access --args 0u8

//# run 0xCAFE::GenericTestModule::combined_generic_nested_access

// Features:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 428ddf43fccbb271bbb22407bf575b12: Report diagnostics and errors to the user during Move compilation.
// 73d278c7618650803046349136e36d3d: Access nested names using a dot notation chain.
