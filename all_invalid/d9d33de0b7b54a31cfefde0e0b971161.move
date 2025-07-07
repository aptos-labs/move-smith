//# publish
module 0xCAFE::GenericContainer {

    use std::vector;

    // A generic struct that can hold a vector of values of any type T
    struct Container<T> has copy, drop, store, key {
        values: vector<T>,
    }

    public fun new<T>(): Container<T> {
        Container<T> {
            values: vector::empty<T>(),
        }
    }

    public fun add<T>(container: &mut Container<T>, value: T) {
        vector::push_back(&mut container.values, value);
    }

    public fun size<T>(container: &Container<T>): u64 {
        vector::length(&container.values)
    }

    // A "runner" function to test adding and sizing the container with u64
    public fun run(): u64 {
        let mut container = new<u64>();
        add(&mut container, 1u64);
        add(&mut container, 2u64);
        add(&mut container, 3u64);
        size(&container)
    }
}
//# run 0xCAFE::GenericContainer::run

//# publish
module 0xCAFE::NestedGeneric {

    use std::vector;
    use 0xCAFE::GenericContainer;

    // A generic struct holding a vector of Containers of T
    struct NestedContainer<T> has copy, drop, store, key {
        containers: vector<GenericContainer::Container<T>>,
    }

    public fun new<T>(): NestedContainer<T> {
        NestedContainer<T> {
            containers: vector::empty<GenericContainer::Container<T>>(),
        }
    }

    public fun add_container<T>(nested: &mut NestedContainer<T>, container: GenericContainer::Container<T>) {
        vector::push_back(&mut nested.containers, container);
    }

    public fun count_containers<T>(nested: &NestedContainer<T>): u64 {
        vector::length(&nested.containers)
    }

    // Runner function to create NestedContainer<u64> with two inner Containers
    public fun run(): u64 {
        let mut nested = new<u64>();

        let mut c1 = GenericContainer::new<u64>();
        GenericContainer::add(&mut c1, 10u64);
        GenericContainer::add(&mut c1, 20u64);

        let mut c2 = GenericContainer::new<u64>();
        GenericContainer::add(&mut c2, 30u64);

        add_container(&mut nested, c1);
        add_container(&mut nested, c2);

        count_containers(&nested)
    }
}
//# run 0xCAFE::NestedGeneric::run

//# publish
module 0xCAFE::GenericStructWithParams {

    // A generic struct containing another generic struct field
    struct Wrapper<T, U> has copy, drop, store, key {
        first: T,
        second: U,
    }

    public fun new_wrapper<T, U>(first: T, second: U): Wrapper<T, U> {
        Wrapper<T, U> {
            first,
            second,
        }
    }

    // Return the first field
    public fun get_first<T, U>(wrapper: &Wrapper<T, U>): &T {
        &wrapper.first
    }

    // Runner function testing Wrapper<u64, u8>
    public fun run(): u64 {
        let wrapper = new_wrapper(100u64, 5u8);
        *get_first(&wrapper)
    }
}
//# run 0xCAFE::GenericStructWithParams::run

//# run
script {
    use 0xCAFE::GenericContainer;
    use 0xCAFE::NestedGeneric;
    use 0xCAFE::GenericStructWithParams;

    fun main() {
        // Use GenericContainer for u8 vector
        let mut container = GenericContainer::new<u8>();
        GenericContainer::add(&mut container, 42u8);
        GenericContainer::add(&mut container, 43u8);

        // Use NestedGeneric for NestedContainer<u64>
        let nested_size = NestedGeneric::run();

        // Use GenericStructWithParams run function
        let first_value = GenericStructWithParams::run();

        // Note: no assertions needed as per instructions
        let _ = container.size();
        let _ = nested_size;
        let _ = first_value;
    }
}

// Featurres:
// 3a91623d3cca10a6d0f0d8e930f82c86: Define a generic type that can contain other types, such as vectors or structs with type parameters.
// c3f41bdb43d4b40a805c62b46bc047a1: Design your functions to avoid having unused parameters and local variables to maintain clean and efficient code.
// bfaf18604daf2a7a1f0d7329aeda4392: Use the '::' syntax to specify the namespace of a module after an address in a module identifier.
