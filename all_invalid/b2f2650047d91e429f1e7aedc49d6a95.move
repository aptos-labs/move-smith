
//# publish
module 0xCAFE::Queue {
    use std::vector;
    use std::signer;

    struct Queue<T> has store {
        items: vector<T>,
        front: u64,
        back: u64,
    }

    // Enqueue and dequeue are movement-based, no mut parameters

    public fun new_queue<T>(): Queue<T> {
        Queue {
            items: vector::empty<T>(),
            front: 0,
            back: 0,
        }
    }

    public fun enqueue<T>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
        q.back = q.back + 1;
    }

    public fun dequeue<T>(q: &mut Queue<T>): T acquires Queue {
        assert!(q.front < q.back, 777);
        let item = *vector::borrow(&q.items, (q.front as u64) as usize);
        q.front = q.front + 1;
        // To avoid memory leak, we can clear vector when front==back
        if (q.front == q.back) {
            // reset vector and counters
            q.items = vector::empty<T>();
            q.front = 0;
            q.back = 0;
        };
        item
    }

    // Runner function to test enqueueing and dequeuing multiple u8
    public fun runner_fifo_test(): bool {
        let q = new_queue<u8>();
        enqueue(&mut q, 1u8);
        enqueue(&mut q, 2u8);
        enqueue(&mut q, 3u8);

        let x1 = dequeue(&mut q);
        let x2 = dequeue(&mut q);
        let x3 = dequeue(&mut q);

        // No asserts needed, just execute
        (x1 == 1u8) && (x2 == 2u8) && (x3 == 3u8)
    }
}


//# run 0xCAFE::Queue::runner_fifo_test


//# publish
module 0xCAFE::ComplexStructs {
    use std::signer;

    struct Inner has copy, drop, store {
        a: u8,
    }

    struct Outer has copy, drop, store {
        name: vector<u8>,
        inner: Inner,
    }

    struct VariantComplex has copy, drop, store {
        tag: u8,
        data: Inner,
    }

    public fun create_outer(name: vector<u8>, a: u8): Outer {
        let inner = Inner {a};
        Outer {name, inner}
    }

    public fun create_variant_complex(a: u8): VariantComplex {
        let data = Inner {a};
        VariantComplex {tag: 1, data}
    }

    public fun runner() {
        let name = b"Bob";
        let _o = create_outer(name, 42);
        let _v = create_variant_complex(55);
    }
}


//# run 0xCAFE::ComplexStructs::runner


//# publish
module 0xCAFE::AbilitiesTest {
    // Type param T requires key + copy + drop
    struct Container<T: key + copy + drop> has key, store {
        t: T
    }

    public fun new_container<T: key + copy + drop>(t: T): Container<T> {
        Container { t }
    }

    public fun runner() {
        let c = new_container<u8>(10u8);
        let c2 = new_container<bool>(true);
        let _ = c;
        let _ = c2;
    }
}


//# run 0xCAFE::AbilitiesTest::runner


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
