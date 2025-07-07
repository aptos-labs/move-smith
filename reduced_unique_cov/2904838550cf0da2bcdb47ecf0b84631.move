
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::signer;

    struct Item has copy, drop, store {
        val: u64,
    }

    // A FIFO queue implemented as a vector with front index
    struct Queue has store {
        items: vector<Item>,
        front: u64, // index of the front item
    }

    public fun create_queue(): Queue {
        Queue {
            items: vector::empty<Item>(),
            front: 0,
        }
    }

    public fun enqueue(q: &mut Queue, val: u64) {
        let item = Item { val };
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue(q: &mut Queue): Item {
        let len = vector::length(&q.items);
        assert!(q.front < (len as u64), 1);
        let item = *vector::borrow(&q.items, (q.front as u64) as u64);
        q.front = q.front + 1;
        if (q.front == (len as u64)) {
            // Reset queue to empty
            q.front = 0;
            q.items = vector::empty<Item>();
        };
        item
    }

    // Test function that enqueues n items and dequeues them all, no args, just runs actions
    public fun runner() {
        let q = create_queue();

        enqueue(&mut q, 10);
        enqueue(&mut q, 20);
        enqueue(&mut q, 30);
        enqueue(&mut q, 40);
        enqueue(&mut q, 50);

        let i1 = dequeue(&mut q);
        let i2 = dequeue(&mut q);
        let i3 = dequeue(&mut q);
        let i4 = dequeue(&mut q);
        let i5 = dequeue(&mut q);

        // i1.val should be 10
        // i5.val should be 50
    }
}


//# run 0xCAFE::QueueModule::runner



//# publish
module 0xCAFE::ComplexStructs {
    use std::vector;

    struct RefHolder<T: copy+drop> has copy, drop, store {
        reference: T,
    }

    struct ComplexSingleton<T: copy+drop> has store {
        field1: u64,
        inner: RefHolder<T>,
    }

    enum ComplexEnum<T: copy+drop + store> has store {
        Variant1,
        Variant2(RefHolder<T>),
        Variant3 {
            val: u64,
            nested: ComplexSingleton<T>,
        },
    }

    public fun create_singleton<T: copy+drop>(val: T): ComplexSingleton<T> {
        let inner = RefHolder<T> { reference: val };
        ComplexSingleton {
            field1: 42,
            inner,
        }
    }

    public fun create_enum_variant2<T: copy+drop + store>(val: T): ComplexEnum<T> {
        let rh = RefHolder<T> { reference: val };
        ComplexEnum::Variant2(rh)
    }

    public fun create_enum_variant3<T: copy+drop + store>(val: T): ComplexEnum<T> {
        let singleton = create_singleton(val);
        ComplexEnum::Variant3 {
            val: 99,
            nested: singleton
        }
    }

    // Runner function that exercises the creation without any args
    public fun runner() {
        let _single = create_singleton(10u64);
        let _v2 = create_enum_variant2(20u64);
        let _v3 = create_enum_variant3(30u64);
    }
}


//# run 0xCAFE::ComplexStructs::runner



//# publish
module 0xCAFE::AbilityCombine {
    // Demonstrate a struct with multiple type parameters constrained with "+" syntax
    struct MultiAbility<T: copy+drop+store> has store {
        field: T,
    }

    struct DoubleGeneric<T: copy+drop+store, U: drop+store> has store {
        val1: T,
        val2: U,
    }

    public fun create_multi_ability(): MultiAbility<u64> {
        MultiAbility { field: 123u64 }
    }

    public fun create_double_generic(): DoubleGeneric<u8, u64> {
        DoubleGeneric {
            val1: 1u8,
            val2: 999u64,
        }
    }

    public fun runner() {
        let _a = create_multi_ability();
        let _b = create_double_generic();
    }
}


//# run 0xCAFE::AbilityCombine::runner


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
