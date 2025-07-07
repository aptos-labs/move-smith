
//# publish
module 0xCAFE::FifoQueue {
    use std::vector;

    /// A struct representing a FIFO queue with vector storage.
    struct Queue<T> has store {
        items: vector<T>,
    }

    public fun new_queue<T>(): Queue<T> {
        Queue {items: vector::empty<T>()}
    }

    public fun enqueue<T>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T>(queue: &mut Queue<T>): T {
        // Instead of borrowing and copying, directly remove returns the removed element, consuming it properly
        vector::remove(&mut queue.items, 0)
    }

    public fun length<T>(queue: &Queue<T>): u64 {
        vector::length(&queue.items)
    }

    /// Test runner function for enqueue and dequeue
    public fun runner() {
        let queue = new_queue<u8>();
        enqueue(&mut queue, 10u8);
        enqueue(&mut queue, 20u8);
        enqueue(&mut queue, 30u8);
        assert!(length(&queue) == 3, 100);
        let a = dequeue(&mut queue);
        assert!(a == 10u8, 101);
        let b = dequeue(&mut queue);
        assert!(b == 20u8, 102);
        let c = dequeue(&mut queue);
        assert!(c == 30u8, 103);
        assert!(length(&queue) == 0, 104);
        // Consume queue so it can be dropped properly
        let Queue { items: _ } = queue;
    }
}




//# run 0xCAFE::FifoQueue::runner
