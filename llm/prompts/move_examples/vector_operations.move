//# publish
module 0xCAFE::VectorOperations {
    use std::vector;

    fun example_vector_usage() {
        (vector[]: vector<bool>);
        (vector[0u8, 1u8, 2u8]: vector<u8>);
        (vector<u128>[]: vector<u128>);
        (vector<address>[@0x42, @0x100]: vector<address>);

        let v = vector::empty<u64>();
        vector::push_back(&mut v, 5);
        vector::push_back(&mut v, 6);

        assert!(*vector::borrow(&v, 0) == 5, 42);
        assert!(*vector::borrow(&v, 1) == 6, 42);
        assert!(vector::pop_back(&mut v) == 6, 42);
        assert!(vector::pop_back(&mut v) == 5, 42);
    }
}