//# publish
module 0xDEAD::TestModule {
    use std::vector;

    // Define a simple struct with vector inside for testing
    struct Container has store, key {
        id: u64,
        data: vector<u8>,
    }

    // Function to create a container with an empty vector
    public fun create_container(id: u64): Container {
        let v: vector<u8> = vector::empty();
        let c = Container {id, data: v};
        c
    }

    // Function to add elements to container's vector
    public fun add_elements(c: &mut Container, elements: vector<u8>) {
        let len = vector::length(&elements);
        let i: u64 = 0;
        while (i < len) {
            let element = *vector::borrow(&elements, i);
            vector::push_back(&mut c.data, element);
            i = i + 1;
        };
    }

    // Function to get vector literal with mixed values
    public fun get_mixed_vector(): vector<u8> {
        vector[b"abc"[0], b"abc"[1], b"abc"[2], 255u8]
    }

    // Function to test vector comparison and a complex vector usage
    public fun vector_operations() {
        // Create vectors with different types
        let v1: vector<u8> = vector[b"a", b"b", b"c"];
        let v2: vector<u8> = vector[b"a", b"b", b"c"];

        // Compare vectors' length
        assert!(vector::length(&v1) == vector::length(&v2), 0);

        // Use get_mixed_vector
        let mixed_v = get_mixed_vector();

        // Create vector of addresses for testing
        let addr_vector: vector<address> = vector[@0x1, @0x2];

        // Push back to address vector
        vector::push_back(&mut addr_vector, @0x3);
        // Borrow and check value
        assert!(*vector::borrow(&addr_vector, 2) == @0x3, 42);
    }
}
