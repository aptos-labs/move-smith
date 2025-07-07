
//# publish
module 0xCAFE::TupleStructTest {
    use std::vector;

    struct TupleStruct(u8, u8, u8);

    struct Container has store {
        arr: vector<u8>
    }

    public fun access_tuple_fields(): (u8, u8, u8) {
        let t = TupleStruct(10, 20, 30);
        let f0 = t.0;
        let f1 = t.1;
        let f2 = t.2;
        (f0, f1, f2)
    }

    public fun mutate_vector_element(): vector<u8> {
        let v = vector[1u8, 2u8, 3u8];
        // Mutate the second element (index 1)
        *vector::borrow_mut(&mut v, 1) = 42u8;
        v
    }

    public fun destructuring_left_to_right(): (u8, u8, u8) {
        let x = 1u8;
        let t = TupleStruct(x, {x = x + 1; x}, {x = x + 1; x});
        // Evaluate fields in left-to-right order, mutating `x` after each field
        let TupleStruct(a, b, c) = t;
        (a, b, c)
    }
}



//# run 0xCAFE::TupleStructTest::access_tuple_fields



//# run 0xCAFE::TupleStructTest::mutate_vector_element



//# run 0xCAFE::TupleStructTest::destructuring_left_to_right
