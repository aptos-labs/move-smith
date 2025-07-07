
//# publish
module 0xCAFE::CustomLayout {
    use std::vector;

    // Define a struct with custom layout: fields with different types and reorder
    // Custom layout here means fields arranged explicitly, diverse simple types
    struct CustomStruct has copy, drop, store {
        b: bool,
        n: u64,
        a: u8,
    }

    // A generic queue struct with vector and start index for dequeue
    struct Queue<T> has store {
        data: vector<T>,
        start: u64
    }

    // Initialize queue with empty vector and start = 0
    public fun init_queue<T>(): Queue<T> {
        Queue {
            data: vector::empty<T>(),
            start: 0u64
        }
    }

    // Enqueue an item at the back
    public fun enqueue<T>(q: &mut Queue<T>, item: T) {
        let d = &mut q.data;
        vector::push_back(d, item);
    }

    // Dequeue an item from the front (FIFO)
    // Returns Option<T>, None if empty
    public fun dequeue<T>(q: &mut Queue<T>): Option<T> {
        if (q.start < vector::length(&q.data)) {
            let item = *vector::borrow(&q.data, q.start as u64);
            q.start = q.start + 1;
            Some(item)
        } else {
            None
        }
    }

    // A function that tests enqueue and dequeue, returning first dequeued and 
    // the length of remaining queue after a dequeue. 
    // This tests FIFO order correctness.
    public fun test_queue(): (Option<u8>, u64) {
        let q = init_queue<u8>();
        enqueue(&mut q, 1u8);
        enqueue(&mut q, 2u8);
        enqueue(&mut q, 3u8);
        let first = dequeue(&mut q);
        let remaining_len = (vector::length(&q.data) as u64) - q.start;
        (first, remaining_len)
    }

    // A function receiving two vectors KEYS and VALUES,
    // returning a vector where each KEY element is mapped to key + 2
    // and each VALUE element is incremented by 3.
    // This tests vector mapping, generic usage, and return without error.
    public fun map_keys_and_values(keys: vector<u8>, values: vector<u8>): (vector<u8>, vector<u8>) {
        let keys_length = vector::length(&keys);
        assert!(keys_length == vector::length(&values), 1000);

        let new_keys = vector::empty<u8>();
        let new_values = vector::empty<u8>();

        let i = 0;
        while (i < keys_length) {
            let k = *vector::borrow(&keys, i);
            let v = *vector::borrow(&values, i);
            vector::push_back(&mut new_keys, k + 2);
            vector::push_back(&mut new_values, v + 3);
            i = i + 1;
        };
        (new_keys, new_values)
    }
}


//# run 0xCAFE::CustomLayout::test_queue


//# run 0xCAFE::CustomLayout::map_keys_and_values --args vector[1u8, 3u8, 5u8] vector[10u8, 20u8, 30u8]


// Featurres:
// 7630a49c796b41afbc905b3ee0e88685: Specify custom layouts (fields) for struct definitions in Move.
// 3b57df797132c77f41933d63ad686524: Test that queue creation, enqueue, and dequeue operations on a generic queue work correctly and maintain FIFO (first-in, first-out) order.
// 627844f84ecfc748b79956e89aeb9bf1: Test that calling the init function correctly maps the KEYS to their lengths plus two and adds three to each value in VALUES without errors.
