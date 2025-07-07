//# publish
module 0xABC::mut_ref_tests {
    use std::vector;

    struct Container has drop {
        count: u64,
        nested: Nested,
    }

    struct Nested has drop {
        value: u64,
        flag: bool,
    }

    /// Helper function to borrow mutable reference to an element in a vector safely.
    public fun borrow_mut_element<Element>(
        vec: &mut vector<Element>,
        index: u64,
    ): &mut Element {
        vector::borrow_mut(vec, index)
    }

    /// Helper function to update nested fields in the Container
    public fun update_nested(s: &mut Container, new_value: u64, new_flag: bool) {
        s.nested.value = new_value;
        s.nested.flag = new_flag;
    }

    /// Function to test aliasing mutable references to nested structures.
    public fun aliasing_nested_refs(s: &mut Container): bool {
        let nested_ref1 = &mut s.nested;
        let nested_ref2 = &mut s.nested;
        // Mutate through first reference
        nested_ref1.value = nested_ref1.value + 1;
        // Mutate through second reference
        nested_ref2.flag = !nested_ref2.flag;
        // Check consistency
        nested_ref1.value == s.nested.value && nested_ref2.flag == s.nested.flag
    }

    /// Function to conditionally borrow a mutable reference based on a boolean flag.
    public fun conditional_borrow(s: &mut u64, flag: bool): &mut u64 {
        if (flag) {
            s
        } else {
            &mut 0 // Returns mutable reference to a temporary (simulate safe scenario)
        }
    }

    /// Runner function to perform complex nested reference manipulations.
    public fun run_complex_ref_tests() {
        let vec = vector[10u64, 20, 30, 40];
        let mut container = Container {
            count: 0,
            nested: Nested {
                value: 100,
                flag: true,
            },
        };

        // Borrow mutable element at index 1
        let elem = borrow_mut_element(&mut vec, 1);
        *elem = 200;

        // Update nested fields in container
        update_nested(&mut container, 555, false);

        // Test aliasing of nested references
        let alias_result = aliasing_nested_refs(&mut container);
        assert!(alias_result, 0);

        // Conditional borrow when flag is true
        let mut num = 42u64;
        let ref_conditional_true = conditional_borrow(&mut num, true);
        *ref_conditional_true = 99;

        // Conditional borrow when flag is false
        let ref_conditional_false = conditional_borrow(&mut num, false);
        *ref_conditional_false = 123;

        // Verify mutated values
        assert!(*ref_conditional_true == 99, 1);
        // The false branch writes to a temporary, so original num remains unchanged
        assert!(*ref_conditional_false == 123, 2);
        assert!(num == 123, 3);
    }
}

//# run 0xABC::mut_ref_tests::run_complex_ref_tests

    ```