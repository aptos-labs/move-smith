
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
    // Removed 'acquires vector' as 'vector' resource is not a resource type
    public fun create_nested_vector() {
        let vec: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut vec, 42);
        vector::push_back(&mut vec, 43);
        let container = Container<vector<u8>> { value: vec };
        // To actually use it, perhaps return or process
        // For test, just create and discard
        // Alternatively, you might want to return it
        // but since test calls create_nested_vector() as argument, it should return container.value
        // so change return to container.value
        // So, add explicit return:
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
    public fun impure_function() acquires vector {
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
        let nested_vec = create_nested_vector();
        let _ = access_nested_field(nested_vec);
        let _ = access_deep_field();
        // This will produce an impurity error message
        complex_nested_impure<u8>();
    }
}


//# run 0xCAFE::GenericTypeInteraction::run_all_tests
