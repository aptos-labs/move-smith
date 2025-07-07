
//# publish
module 0xBEEFsTest {
    use std::vector;
    use std::signer;

    // Helper function to enqueue items into a vector
    public fun enqueue_all(v: &mut vector<u64>, items: vector<u64>) {
        let len = vector::length(&items);
        let i = 0u64;
        while (i < len) {
            vector::push_back(v, *vector::borrow(&items, i));
            i = i + 1;
        }
    }

    // Helper function to dequeue one item (FIFO)
    public fun dequeue_one(v: &mut vector<u64>): option<u64> {
        if (vector::length(v) == 0) {
            option::none()
        } else {
            let item = vector::pop_front(v);
            option::some(item)
        }
    }

    // Runner function to exercise the features
    public fun test_behavior() {
        // 1. Access multiple lvalues and associated expressions in a list
        // Initialize a vector with some values
        let vec_values = vector::empty<u64>();
        let initial_items = vector![10u64, 20u64, 30u64];
        enqueue_all(&mut vec_values, initial_items);

        // Access multiple values in the vector via range-based iteration
        let sum: u64 = 0;
        let len = vector::length(&vec_values);
        let i = 0u64;
        while (i < len) {
            let value_ref = vector::borrow(&vec_values, i);
            let value = *value_ref;
            sum = sum + value;
            i = i + 1;
        }

        // 2. Increment a mutable reference inside a loop, affecting subsequent bound
        let bound = 3u64;
        let index = 0u64;
        while (index < bound) {
            let _ = *vector::borrow(&vec_values, index);
            // For demonstration: increment bound each iteration
            bound = bound + 1;
            index = index + 1;
        }

        // Validate the final bound (not doing explicit assertion here as per instruction)

        // 3. Enqueue multiple items and then dequeue them to verify FIFO order
        let queue = vector::empty<u64>();
        enqueue_all(&mut queue, vector![100u64, 200u64, 300u64]);

        // Dequeue items, should get 100, 200, 300 in order
        let first_item = dequeue_one(&mut queue);
        let second_item = dequeue_one(&mut queue);
        let third_item = dequeue_one(&mut queue);
        let fourth_item = dequeue_one(&mut queue); // should be none

        // For clarity, no assertions, just variable assignments
        let _ = first_item;
        let _ = second_item;
        let _ = third_item;
        let _ = fourth_item;
    }
}

// To call the test function correctly, use: 0xBEEFsTest::test_behavior()
