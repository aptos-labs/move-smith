
//# publish
module 0xCAFE::GenericTypeInteraction {
    use std::vector;

    // Generic struct with nested type parameter
    struct Container<T> has copy, drop, store {
        value: T,
    }

    // Another nested generic struct
    struct NestedContainer<U> has copy, drop, store {
        container: Container<U>,
        label: u8,
    }

    // Function that retrieves a nested field through dot notation
    public fun access_nested_field<T: copy + drop + store>(container: Container<T>): T {
        container.value
    }

    // Function that creates a nested container with vector of u8
    public fun create_nested_vector() acquires vector {
        let vec: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut vec, 42);
        vector::push_back(&mut vec, 43);
        let container = Container<vector<u8>> { value: vec };
        container.value
    }

    // Generic function that calls an impure function within a spec expression
    public fun impure_in_spec<T: copy + drop + store>(val: T): vector<u8> {
        // Call to impure function inside spec - should produce error
        let _ = impure_function();
        // Return a dummy vector
        let v: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut v, 255);
        v
    }

    // Helper impure function
    public fun impure_function() acquires Vector {
        // Dummy impure function
        let v: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut v, 1);
        v
    }

    // Function that accesses nested module and fields using dot notation
    public fun access_deep_field() {
        let nested_obj = NestedContainer<u16> {
            container: Container { value: 123u16 },
            label: 5,
        };
        let deep_value = nested_obj.container.value; // dot notation chaining
        let _ = deep_value;
    }

    // Function that combines nested generic containers with impure functions
    public fun complex_nested_impure<T: copy + drop + store>() {
        // This should generate an impurity error due to impure call within spec
        let _ = impure_in_spec(default<T>());
    }

    // Wrapper to run the above complex test
    public fun run_all_tests() {
        let _ = access_nested_field(create_nested_vector());
        let _ = access_deep_field();
        // This will produce an impurity error message
        complex_nested_impure<u8>();
    }
}

//# run 0xCAFE::GenericTypeInteraction::run_all_tests


// Featurres:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// 834db50012e317ce95b4a6e911c524dd: Receive detailed error messages when a specification expression calls an impure Move function.
// 73d278c7618650803046349136e36d3d: Access nested names using a dot notation chain.
