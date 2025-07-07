//# publish
module 0xDEAD::PrimitiveAndLargeVectorsTest {
    use std::vector;

    struct PrimitiveFields has copy, drop, store {
        a: u8,
        b: u16,
        c: u32,
        d: u64,
        e: u128
    }

    public fun create_primitive_struct(a: u8, b: u16, c: u32, d: u64, e: u128): PrimitiveFields {
        PrimitiveFields {a, b, c, d, e}
    }

    public fun pack_struct_fields(a: u8, b: u16, c: u32, d: u64, e: u128): PrimitiveFields {
        let s = PrimitiveFields {a, b, c, d, e};
        s
    }

    public fun create_and_use_large_vector(): vector<u8> {
        let large_vector: vector<u8> = vector::empty<u8>();
        vector::push_back(&mut large_vector, 0xAA);
        vector::push_back(&mut large_vector, 0xBB);
        vector::push_back(&mut large_vector, 0xCC);
        vector::push_back(&mut large_vector, 0xDD);
        vector::push_back(&mut large_vector, 0xEE);
        vector::push_back(&mut large_vector, 0xFF);
        vector::push_back(&mut large_vector, 0x11);
        vector::push_back(&mut large_vector, 0x22);
        vector::push_back(&mut large_vector, 0x33);
        vector::push_back(&mut large_vector, 0x44);
        vector::push_back(&mut large_vector, 0x55);
        vector::push_back(&mut large_vector, 0x66);
        vector::push_back(&mut large_vector, 0x77);
        vector::push_back(&mut large_vector, 0x88);
        vector::push_back(&mut large_vector, 0x99);
        vector::push_back(&mut large_vector, 0x00);
        vector::push_back(&mut large_vector, 0xAB);
        vector::push_back(&mut large_vector, 0xCD);
        vector::push_back(&mut large_vector, 0xEF);

        large_vector
    }

    public fun vector_literal_with_large_data(): vector<u8> {
        // Corrected: use std::vector::vector::from_elem
        vector::vector_from_elem(20, 0x42)
    }

    // To test compilation with large vectors, create a function with large vector literal
    // (assertions are not required as per guidelines)
    public fun run_large_vector_test() {
        let v1 = create_and_use_large_vector();
        let v2 = vector_literal_with_large_data();
        // No return and assertion needed; just to test compilation and execution
        (v1, v2)
    }
}


//# run 0xDEAD::PrimitiveAndLargeVectorsTest::run_large_vector_test
