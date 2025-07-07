
//# publish
module 0xCAFE::QueueTest {
    use std::vector;

    struct Queue<T> has store {
        items: vector<T>,
    }

    public fun create_queue<T>(): Queue<T> {
        let items = vector::empty<T>();
        Queue { items }
    }

    public fun enqueue<T>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T>(queue: &mut Queue<T>): T {
        assert!(!vector::is_empty(&queue.items), 1001);
        vector::remove(&mut queue.items, 0)
    }

    public fun runner() {
        let q = create_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);

        let _sum = a + b + c;

        // Since Queue<u8> does NOT have drop ability,
        // and q goes out of scope here, consume it to avoid drop error.
        // Unpack the struct to consume it
        let Queue { items: _ } = q;
    }
}
