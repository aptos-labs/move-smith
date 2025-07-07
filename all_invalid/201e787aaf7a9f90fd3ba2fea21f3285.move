
//# publish
module 0xCAFE::GenericContainerTest {
    use std::vector;

    // Generic struct to hold any type T
    struct Container<T> has copy, drop, store, key {
        value: T,
    }

    // A parameterized struct to be used inside containers
    struct ParameterizedStruct<X> has copy, drop {
        field: X
    }

    public fun create_container_with_vector() acquires Container {
        let vec: vector<u8> = vector::empty();
        vector::push_back(&mut vec, 42u8);
        let c = Container { value: vec };
        c
    }

    public fun create_container_with_param_struct() acquires Container {
        let ps = ParameterizedStruct { field: 555u64 };
        let c = Container { value: ps };
        c
    }
}


//# run 0xCAFE::GenericContainerTest::create_container_with_vector

//# run 0xCAFE::GenericContainerTest::create_container_with_param_struct


// Featurres:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 2b30b1d02d5a7dd1436a0503aacee40a: Deserialize a compiled Move module from a file.
// 73d278c7618650803046349136e36d3d: Access nested names using a dot notation chain.
