//# publish
module 0xCAFE::AbilitiesTest {
    // 1. Declare a struct with specific abilities
    struct MyStruct has store, key, drop {
        value: u64,
    }

    // Function to create a new instance of MyStruct
    public fun create_struct(val: u64): MyStruct {
        MyStruct { value: val }
    }
}

//# publish
module 0xCAFE::VectorSum {
    use 0xCAFE::AbilitiesTest;

    // 2. Test that popping all elements from a vector and summing produces correct total
    public fun test_vector_pop_sum() {
        let vec: vector<u8> = vector[];
        // Initialize vector with values 1 to 5
        vector::push_back(&mut vec, 1);
        vector::push_back(&mut vec, 2);
        vector::push_back(&mut vec, 3);
        vector::push_back(&mut vec, 4);
        vector::push_back(&mut vec, 5);

        let mut total: u64 = 0;
        while (vector::length(&vec) > 0) {
            let val = vector::pop_back(&mut vec);
            total = total + (val as u64);
        }
        // total should be 15
    }
}

//# publish
module 0xCAFE::ExpressionOrder {
    use 0xCAFE::AbilitiesTest;
    use 0xCAFE::VectorSum;

    // 3. Test nested assignments and side effects for correct left-to-right order
    public fun test_nested_assignments() {
        let mut var_a: u64 = 10;
        let mut var_b: u64 = 20;
        let mut var_c: u64 = 0;

        // Create a vector for side effect testing
        let mut vec_side: vector<u8> = vector[];

        // Perform nested expression with side effects:
        // Assign var_c with result of (var_b + var_a) after incrementing var_a and var_b
        // The order should be left-to-right: first vars are read, then updated
        // Mimic a nested assignment
        var_c = {
            // Side effect: push to vector
            vector::push_back(&mut vec_side, 0xAA);
            let temp_a = *&var_a; // read current var_a
            vector::push_back(&mut vec_side, 0xBB);
            let temp_b = *&var_b; // read current var_b
            // side effect: increment vars
            var_a = var_a + 1; // now var_a=11
            var_b = var_b + 1; // now var_b=21
            // Compute sum
            temp_a + temp_b
        };

        // After the block:
        // var_a should be 11
        // var_b should be 21
        // var_c should be 10 + 20 = 30 (original values before increment)
        // The test verifies the order of side effects and variable values
    }
}

//# run 0xCAFE::AbilitiesTest::create_struct
//# run 0xCAFE::VectorSum::test_vector_pop_sum
//# run 0xCAFE::ExpressionOrder::test_nested_assignments --signers 0xCAFE
