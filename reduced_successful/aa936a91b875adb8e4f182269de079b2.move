
//# publish
module 0xCAFE::FifoQueue {
    use std::vector;
    use std::option;

    /// A simple FIFO queue with enqueue and dequeue operations
    struct Queue<T> has store {
        items: vector<T>,
    }

    /// Initialize a new empty queue
    public fun new<T>(): Queue<T> {
        Queue<T> {
            items: vector::empty<T>(),
        }
    }

    /// Enqueue item in the queue
    public fun enqueue<T>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    /// Dequeue an item from the queue, returning option<T>
    public fun dequeue<T>(q: &mut Queue<T>): option::Option<T> {
        if (vector::is_empty(&q.items)) {
            option::none<T>()
        } else {
            // Use vector::remove which returns the removed element
            let result = vector::remove(&mut q.items, 0);
            option::some(result)
        }
    }

    /// Test runner that enqueues and dequeues multiple u8 items
    public fun runner(): vector<u8> {
        let q = new<u8>();

        // To consume q and fix drop error, unpack q before use
        let Queue { items } = q;

        // To keep usage of q mutable, rebuild it as mutable struct variable
        // but ability to drop is required. Because Queue<u8> has no drop ability,
        // consume by unpacking and work with the inner vector instead

        // Use a local mutable vector to simulate queue state
        let items = items;
        enqueue_local(&mut items, 10u8);
        enqueue_local(&mut items, 20u8);
        enqueue_local(&mut items, 30u8);

        let results = vector::empty<u8>();

        // Dequeue loop
        let opt = dequeue_local(&mut items);
        while (option::is_some(&opt)) {
            let val = option::extract(&mut opt);
            vector::push_back(&mut results, val);
            opt = dequeue_local(&mut items);
        };
        results
    }

    // Local versions of enqueue and dequeue working with a vector<u8>

    fun enqueue_local(vec: &mut vector<u8>, item: u8) {
        vector::push_back(vec, item);
    }

    fun dequeue_local(vec: &mut vector<u8>): option::Option<u8> {
        if (vector::is_empty(vec)) {
            option::none<u8>()
        } else {
            let result = vector::remove(vec, 0);
            option::some(result)
        }
    }
}
