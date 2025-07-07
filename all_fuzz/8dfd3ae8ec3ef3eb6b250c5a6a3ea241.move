
//# publish
module 0xCAFE::QueueTest {
    use std::vector;

    struct Queue<T: copy + drop> has store {
        items: vector<T>
    }

    public fun create_empty<T: copy + drop>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    public fun enqueue<T: copy + drop>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T: copy + drop>(queue: &mut Queue<T>): T {
        let item = *vector::borrow(&queue.items, 0);
        let len = vector::length(&queue.items);
        // remove front element by swapping with last and popping back is not FIFO,
        // so build a new vector without first element
        let new_items = vector::empty<T>();
        let i = 1;
        while (i < len) {
            vector::push_back(&mut new_items, *vector::borrow(&queue.items, i));
            i = i + 1;
        };
        queue.items = new_items;
        item
    }

    // Singleton struct with a field referencing a variant struct
    struct SingleWithVariant has store, key {
        v: Variant,
    }

    // Variant enum with fields referencing types
    enum Variant has copy, drop {
        Unit,
        IntVal(u64),
        RefVal(0xCAFE::QueueTest::Queue<u8>),
    }

    // Struct with multi-ability type param, stores a value and a vector
    struct MultiAbilityStruct<T: store + copy + drop> has store {
        val: T,
        vals: vector<T>,
    }

    public fun multi_ability_struct_new<T: store + copy + drop>(val: T): MultiAbilityStruct<T> {
        MultiAbilityStruct {
            val,
            vals: vector::empty<T>(),
        }
    }

    public fun multi_ability_struct_push<T: store + copy + drop>(s: &mut MultiAbilityStruct<T>, v: T) {
        vector::push_back(&mut s.vals, v);
    }

    public fun runner() {
        // Test 1: enqueue multiple and dequeue FIFO
        let queue = create_empty<u8>();
        enqueue(&mut queue, 10u8);
        enqueue(&mut queue, 20u8);
        enqueue(&mut queue, 30u8);

        let first = dequeue(&mut queue);
        let second = dequeue(&mut queue);
        let third = dequeue(&mut queue);

        // Test 2: create singleton with variant referencing a queue
        let inner_queue = create_empty<u8>();
        let variant = Variant::RefVal(inner_queue);
        let _singleton = SingleWithVariant { v: variant };

        // Test 3: create multi-ability struct and push values
        let mas = multi_ability_struct_new<u64>(5u64);
        multi_ability_struct_push(&mut mas, 10u64);
        multi_ability_struct_push(&mut mas, 15u64);
    }
}


//# run 0xCAFE::QueueTest::runner


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
