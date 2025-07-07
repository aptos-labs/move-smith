//# publish
module 0xA11::mutable_borrow_tests {
    use std::vector;

    // Struct for nested field updates
    struct Counter has drop {
        count: u64,
        nested: Nested,
    }

    struct Nested has drop {
        value: u64,
    }

    // Function to borrow mutable reference to a vector element
    public fun get_element_mut<Element>(
        vec: &mut vector<Element>,
        index: u64,
    ): &mut Element {
        vector::borrow_mut(vec, index)
    }

    // Function to modify a nested struct field via mutable reference
    public fun update_nested(counter: &mut Counter, new_value: u64) {
        counter.nested.value = new_value;
    }

    // Function to test aliasing and mutability with references
    fun aliasing_test() {
        let mut data = Counter { count: 0, nested: Nested { value: 10 } };
        let count_ref = &mut data.count;
        *count_ref = 42;

        // Borrow nested field and modify via mutable ref
        update_nested(&mut data, 99);
        assert!(data.nested.value == 99, 0);
        // Ensure original nested value is updated
        assert!(data.nested.value == 99, 1);
        // Verify count was updated
        assert!(data.count == 42, 2);
    }

    // Function to test that mutable borrow of a parameter doesn't affect original value outside
    public fun modify_parameter(p: &mut u64): u64 {
        *p = *p + 10;
        *p
    }

    // Runner to exercise above functions
    public fun run_tests() {
        // Prepare vector and get mutable element
        let mut vec = vector[1u64, 2u64, 3u64];
        let element_ref = get_element_mut(&mut vec, 1);
        *element_ref = 42;
        assert!(*element_ref == 42, 3);
        assert!(vector::borrow(&vec, 1) == 42, 4);

        // Test nested struct mutation
        aliasing_test();

        // Test mutation of parameter
        let mut num = 7;
        let result = modify_parameter(&mut num);
        assert!(result == 17, 5);
        // Check original num after modification
        assert!(num == 17, 6);
    }
}

//# run 0xA11::mutable_borrow_tests::run_tests