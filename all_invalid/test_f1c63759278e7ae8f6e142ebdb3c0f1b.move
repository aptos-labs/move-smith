//# publish
module 0xabcde::large_vector_tests {
    use std::vector;

    // Helper function to generate a vector with 1026 elements
    public fun generate_large_vector(): vector<u64> {
        let mut v = vector::empty<u64>();
        let mut i = 0;
        while (i < 1026) {
            vector::push_back(&mut v, i);
            i = i + 1;
        }
        v
    }

    // Helper function to generate a large predefined vector
    public fun generate_large_predefined_vector(): vector<u64> {
        let elements = [
            987654321, 123456789, 192837465, 102938475, 564738291,
            111111111, 222222222, 333333333, 444444444, 555555555,
            666666666, 777777777, 888888888, 999999999, 123123123,
            321321321, 213213213, 312312312, 456456456, 789789789,
            101010101, 202020202, 303030303, 404040404, 505050505,
            606060606, 707070707, 808080808, 909090909, 121212121,
            232323232, 343434343, 454545454, 565656565, 676767676,
            787878787, 898989898, 909090909, 123456789, 987654321
        ];
        let v = vector::empty<u64>();
        let mut i = 0;
        while (i < vector::length(&elements)) {
            vector::push_back(&mut v, *vector::mut_borrow(&elements, i));
            i = i + 1;
        }
        v
    }

    // Runner functions for getting lengths
    public fun get_large_vec_length(): u64 {
        let v = generate_large_vector();
        vector::length(&v)
    }

    public fun get_predefined_vec_length(): u64 {
        let v = generate_large_predefined_vector();
        vector::length(&v)
    }
}

//# run 0xabcde::large_vector_tests::get_large_vec_length

//# run 0xabcde::large_vector_tests::get_predefined_vec_length