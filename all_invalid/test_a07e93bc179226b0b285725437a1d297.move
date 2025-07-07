//# publish
module 0xAB::nested_structs_test {
    struct InnerStruct has drop {
        value: u64,
        count: u64
    }

    struct OuterStruct has drop {
        id: u64,
        inner: InnerStruct,
    }

    fun mutate_nested_structs() {
        let inner = InnerStruct { value: 10, count: 5 };
        let mut outer = OuterStruct { id: 42, inner };
        
        // Borrow mutable references to inner struct and outer id
        let OuterStruct { id: outer_id, inner: inner_ref } = &mut outer;
        let InnerStruct { value: inner_value, count: inner_count } = inner_ref;

        // Verify initial values
        assert!(*outer_id == 42, 0);
        assert!(*inner_value == 10, 1);
        assert!(*inner_count == 5, 2);

        // Mutate inner struct fields
        *inner_value = *inner_value + 15; // 10 + 15 = 25
        *inner_count = *inner_count + 10; // 5 + 10 = 15
        // Mutate outer id
        *outer_id = *outer_id + 58; // 42 + 58 = 100

        // Verify mutated values
        assert!(*outer_id == 100, 3);
        assert!(*inner_value == 25, 4);
        assert!(*inner_count == 15, 5);
    }
}

//# run 0xAB::nested_structs_test::mutate_nested_structs