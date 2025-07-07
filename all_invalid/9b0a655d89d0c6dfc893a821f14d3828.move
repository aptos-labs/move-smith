
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
        c // Return the container
    }

    public fun create_container_with_param_struct() acquires Container {
        let ps = ParameterizedStruct { field: 555u64 };
        let c = Container { value: ps };
        c // Return the container
    }
}


//# run 0xCAFE::GenericContainerTest::create_container_with_vector


//# run 0xCAFE::GenericContainerTest::create_container_with_param_struct
