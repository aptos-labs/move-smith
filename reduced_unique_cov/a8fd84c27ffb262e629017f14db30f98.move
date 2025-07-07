
//# publish
module 0xCAFE::QueueTest {
    use std::vector;
    use std::option;

    // FIFO queue struct with a vector to store items
    struct Queue<T> has store {
        items: vector<T>,
    }

    // A variant struct with nested struct reference
    struct Nested has copy, drop, store {
        value: u8,
    }

    struct VariantWithReference has store {
        nested: Nested,
        flag: bool,
    }

    // A singleton struct with a field referencing another struct
    struct SingletonRef has key, store {
        inner: Nested,
    }

    // Struct with type parameter constrained by store + copy abilities
    struct MultipleAbility<T: copy + store> has store {
        item: T,
    }

    // Initialize an empty queue
    public fun new_queue<T>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    // Enqueue an item to the queue
    public fun enqueue<T>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    // Dequeue an item from the queue, returns Option<T>
    public fun dequeue<T: copy>(queue: &mut Queue<T>): option::Option<T> {
        if (vector::is_empty(&queue.items)) {
            option::none<T>()
        } else {
            let item = *vector::borrow(&queue.items, 0);
            // Remove first element by rebuilding the vector without the first element:

            let len = vector::length(&queue.items);
            let new_items = vector::empty<T>();
            let i = 1u64;
            while (i < len) {
                vector::push_back(&mut new_items, *vector::borrow(&queue.items, i));
                i = i + 1;
            };
            queue.items = new_items;
            option::some(item)
        }
    }

    // Public test function to enqueue and then dequeue multiple items to test FIFO order
    public fun test_fifo() {
        let q = new_queue<u8>();
        enqueue(&mut q, 10);
        enqueue(&mut q, 20);
        enqueue(&mut q, 30);

        let first = dequeue(&mut q);
        let second = dequeue(&mut q);
        let third = dequeue(&mut q);

        // consume to silence unused variable warnings
        let _ = first;
        let _ = second;
        let _ = third;
    }

    // Create a VariantWithReference instance to test struct nesting and references
    public fun create_variant_with_ref(): VariantWithReference {
        let nested = Nested { value: 123 };
        VariantWithReference { nested, flag: true }
    }

    // Create a singleton with a nested reference for testing
    public fun create_singleton_ref(s: signer) {
        let nested = Nested { value: 42 };
        let singleton = SingletonRef { inner: nested };
        move_to<SingletonRef>(&s, singleton);
    }

    // Create an instance of MultipleAbility with an u8 (copy + store)
    public fun create_multiple_ability(): MultipleAbility<u8> {
        MultipleAbility { item: 99 }
    }

    // Runner function to test all behaviors
    public fun run() {
        test_fifo();
        let _ = create_variant_with_ref();
        let _ = create_multiple_ability();
    }
}



//# run 0xCAFE::QueueTest::run



//# run 0xCAFE::QueueTest::create_singleton_ref --signers 0xBEEF


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
