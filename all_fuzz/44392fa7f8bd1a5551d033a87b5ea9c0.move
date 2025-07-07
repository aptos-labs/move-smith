
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    // A FIFO queue with generic type T
    // T with copy + drop abilities because we need to enqueue and dequeue values safely
    struct Queue<T> has store {
        items: vector<T>,
    }

    public fun new_queue<T>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    public fun enqueue<T: copy + drop>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T: copy + drop>(q: &mut Queue<T>): T {
        let first = *vector::borrow(&q.items, 0);
        vector::remove(&mut q.items, 0);
        first
    }

    // This function enqueues multiple values and dequeues them to test FIFO order
    public fun test_fifo_order() {
        let q = new_queue<u8>();
        enqueue(&mut q, 5u8);
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 15u8);
        let _first = dequeue(&mut q);
        let _second = dequeue(&mut q);
        let _third = dequeue(&mut q);
    }
}


//# run 0xCAFE::QueueModule::test_fifo_order



//# publish
module 0xCAFE::ComplexSingletons {
    use std::vector;

    // A singleton struct with a vector of addresses and a bool field
    struct SingletonStruct has key, store {
        addrs: vector<address>,
        flag: bool,
    }

    // An enum with variant holding another struct
    struct InnerStruct has copy, drop {
        id: u64,
        valid: bool,
    }

    enum ComplexEnum has store {
        VariantA,
        VariantB(InnerStruct),
    }

    // Example instantiation with complex fields
    public fun create_singleton(): SingletonStruct {
        let addresses = vector[@0x1, @0x2, @0x3];
        SingletonStruct { addrs: addresses, flag: true }
    }

    public fun create_enum_variant(): ComplexEnum {
        let inner = InnerStruct { id: 42, valid: true };
        ComplexEnum::VariantB(inner)
    }
}


//# run 0xCAFE::ComplexSingletons::create_singleton


//# run 0xCAFE::ComplexSingletons::create_enum_variant



//# publish
module 0xCAFE::AbilityCombine {
    // A struct with type parameter T, where T has copy + drop + store abilities
    struct MultiAbilityStruct<T: copy + drop + store> has store {
        value: T,
    }

    public fun create_struct<T: copy + drop + store>(val: T): MultiAbilityStruct<T> {
        MultiAbilityStruct { value: val }
    }

    // A testing function to instantiate with u64 (which has required abilities)
    public fun test_instantiation() {
        let s = create_struct<u64>(10u64);
        let _ = s;
    }
}


//# run 0xCAFE::AbilityCombine::test_instantiation


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
