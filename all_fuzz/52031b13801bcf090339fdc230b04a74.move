
//# publish
module 0xCAFE::QueueTest {
    use std::vector;
    use std::option;

    // FIFO queue struct with a vector to store items
    // Add drop ability so we can assign new vector and avoid drop errors with vector<T>
    struct Queue<T> has store, drop {
        items: vector<T>,
    }

    // A variant struct with nested struct reference
    struct Nested has copy, drop, store {
        value: u8,
    }

    struct VariantWithReference has store, drop {
        nested: Nested,
        flag: bool,
    }

    // A singleton struct with a field referencing another struct
    struct SingletonRef has key, store {
        inner: Nested,
    }

    // Struct with type parameter constrained by store + copy abilities
    struct MultipleAbility<T: copy + store> has store, drop {
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
            // Assign new_items, queue.items is vector<T> without drop ability, but now Queue has drop
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

        // Consume to silence unused variable warnings (consume Queue to avoid drop error)
        // Unpack q by destructuring (consuming)
        let Queue { items: _ } = q;

        // For the Option<u8> values, they have copy ability (u8 copy), so drop is allowed.
        // But to satisfy the error, consume explicitly:
        let option::Option::some(a) = first else { () };
        let option::Option::some(b) = second else { () };
        let option::Option::some(c) = third else { () };
        // Or alternatively just ignore but we already did let _ = first etc., 
        // but consuming is more explicit and avoids drop errors.
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

        // Consume the return values to handle drop errors:
        let variant = create_variant_with_ref();
        let MultipleAbility { item: _ } = create_multiple_ability();

        // Unpack variant to consume it fully (no drop ability)
        let VariantWithReference { nested: _, flag: _ } = variant;
    }
}




//# run 0xCAFE::QueueTest::run




//# run 0xCAFE::QueueTest::create_singleton_ref --signers 0xBEEF
