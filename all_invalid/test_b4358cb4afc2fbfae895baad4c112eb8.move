//# publish
module 0xabc123::logic_tests {
    // Test that conditional assignments and function invocations behave correctly.
    fun compute_value(init: u64, multiplier: u64, condition: bool): u64 {
        let mut val = init;
        if (condition) {
            val = multiplier;
        };
        bar();
        let doubled = val * 2;
        bar();
        let tripled = val * 3;
        doubled + tripled
    }

    fun bar() {
        // Placeholder for function invocation, no-op assertion
        assert!(true, 0);
    }

    // Test that multiple bar calls are invoked appropriately based on condition.
    fun compute_with_conditional_bar(init: u64, multiplier: u64, condition: bool): u64 {
        let mut val = init;
        if (condition) {
            val = multiplier;
        };
        if (condition) {
            bar();
        };
        bar();
        let result = val * 4;
        result
    }

    // Function runner to facilitate testing
    public fun run_tests() {
        // No arguments, just for compiler exercise.
    }
}

//# run 0xabc123::logic_tests::compute_value --args 5 10 true
//# run 0xabc123::logic_tests::compute_value --args 5 10 false
//# run 0xabc123::logic_tests::compute_with_conditional_bar --args 7 14 true
//# run 0xabc123::logic_tests::compute_with_conditional_bar --args 7 14 false

//# publish
module 0xabc123::iteration_tests {
    // Validate that a helper function correctly computes the sum of three numbers, called repeatedly.
    fun sum_three(i: u32, j: u32, k: u32): u32 {
        i + j + k
    }

    // Function that calls sum_three multiple times and sums the results
    public fun aggregate_sum() : u32 {
        let total = 0;
        let (a, b, c) = (1, 2, 3);
        total = total + sum_three(a, b, c); // sum = 6
        let (d, e, f) = (4, 5, 6);
        total = total + sum_three(d, e, f); // sum = 15
        total
    }
}

//# run 0xabc123::iteration_tests::aggregate_sum

//# publish
module 0xabc123::ref_borrowings {
    use std::vector;

    struct Data has drop {
        value: u64,
        nested: struct { inner_value: u64 },
    }

    // Borrow mutable reference of element at index
    public fun borrow_element<'a>(vec: &mut vector::Vector<u64>, index: u64): &mut u64 {
        vector::borrow_mut(vec, index)
    }

    // Borrow mutable reference to nested struct's field
    public fun borrow_nested<'a>(data: &mut Data): &mut u64 {
        &mut data.nested.inner_value
    }

    // Verify that modifying via mutable reference updates original data
    public fun modify_data(data: &mut Data, new_value: u64) {
        data.value = new_value;
    }

    // Test updating nested fields through borrows
    fun test_update_nested() {
        let mut data_instance = Data { value: 100, nested: struct { inner_value: 200 } };
        let nested_ref = borrow_nested(&mut data_instance);
        *nested_ref = 300;
        assert!(*nested_ref == 300, 0);
        assert!(data_instance.nested.inner_value == 300, 1);
        modify_data(&mut data_instance, 999);
        assert!(data_instance.value == 999, 2);
    }

    // Test borrowing and mutability with a vector
    fun test_vector_borrow() {
        let mut vec = vector::empty::<u64>();
        vector::push_back(&mut vec, 42);
        let item_ref = borrow_element(&mut vec, 0);
        *item_ref = 84;
        assert!(*vector::borrow(&vec, 0) == 84, 3);
    }

    // Runner for tests
    public fun run() {
        test_update_nested();
        test_vector_borrow();
    }
}

//# run 0xabc123::ref_borrowings::run