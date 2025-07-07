
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    // A simple generic FIFO queue struct with copy+drop+store abilities
    struct Queue<ItemType> has copy, drop, store {
        items: vector<ItemType>,
    }

    public fun create_queue<ItemType>(): Queue<ItemType> {
        Queue { items: vector::empty<ItemType>() }
    }

    public fun enqueue<ItemType>(q: &mut Queue<ItemType>, item: ItemType) {
        vector::push_back(&mut q.items, item);
    }

    public fun is_empty<ItemType>(q: &Queue<ItemType>): bool {
        vector::is_empty(&q.items)
    }

    public fun dequeue<ItemType>(q: &mut Queue<ItemType>): ItemType {
        assert!(!is_empty(q), 100);
        // Get first element and remove it by shifting left all elements
        let first = *vector::borrow(&q.items, 0);
        let len = vector::length(&q.items);
        let i = 1;
        while (i < len) {
            let val = *vector::borrow(&q.items, i);
            vector::borrow_mut(&mut q.items, i - 1) = val;
            i = i + 1;
        };
        vector::pop_back(&mut q.items);
        first
    }

    // A variant struct with a field that contains a queue of the other struct
    struct Container has copy, drop, store {
        id: u8,
        queue: Queue<u16>,
    }

    // Combine multiple abilities for a type parameter: key+store+copy
    struct MultiAbilityHolder<T: key + store + copy> has key, store {
        value: T
    }

    public fun run_queue_test() {
        let q = create_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);
    }

    public fun run_container_test() {
        let q = create_queue<u16>();
        enqueue(&mut q, 1000u16);
        enqueue(&mut q, 2000u16);
        let container = Container { id: 42, queue: q };
        let _ = container;
    }

    public fun run_multi_ability_holder_test() {
        let holder = MultiAbilityHolder<u64> { value: 1234u64 };
        let _ = holder;
    }
}


//# run 0xCAFE::QueueModule::run_queue_test


//# run 0xCAFE::QueueModule::run_container_test


//# run 0xCAFE::QueueModule::run_multi_ability_holder_test


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
