
//# publish
module 0xCAFE::QueueTesting {
    use std::signer;
    use std::vector;

    struct Wrapper<T: copy + drop + store> has store {
        inner: T,
    }

    struct Queue<T: copy + drop + store> has store {
        items: vector<T>
    }

    public fun create_queue<T: copy + drop + store>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    public fun enqueue<T: copy + drop + store>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T: copy + drop + store>(queue: &mut Queue<T>): T {
        let len = vector::length(&queue.items);
        assert!(len > 0, 1);
        let first = *vector::borrow(&queue.items, 0);
        let temp_vec = vector::empty<T>();
        let len = vector::length(&queue.items);
        let i = 1;
        while (i < len) {
            let v = *vector::borrow(&queue.items, i);
            vector::push_back(&mut temp_vec, v);
            i = i + 1;
        };
        queue.items = temp_vec;
        first
    }

    struct GlobalQueue has store, key {
        queue: Queue<u8>
    }

    public fun init_global_queue(s: signer) {
        let q = create_queue<u8>();
        move_to<GlobalQueue>(&s, GlobalQueue { queue: q });
    }

    public fun conditional_access(s: signer, push_item: bool, value: u8): u8 {
        let addr = signer::address_of(&s);
        if (push_item) {
            let gq_ref_mut = borrow_global_mut<GlobalQueue>(addr);
            enqueue(&mut gq_ref_mut.queue, value);
            0u8
        } else {
            let gq_ref = borrow_global<GlobalQueue>(addr);
            let len = vector::length(&gq_ref.queue.items);
            if (len == 0) {
                0u8
            } else {
                *vector::borrow(&gq_ref.queue.items, 0)
            }
        }
    }

    public fun runner_fifo_test() {
        let q = create_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let d1 = dequeue(&mut q);
        let d2 = dequeue(&mut q);
        let d3 = dequeue(&mut q);
    }

    // Moved the axiom inside a spec block (if your Move toolchain supports it)
    spec {
        axiom forall x: u64 { x + 5 < 100 };
    }
}
