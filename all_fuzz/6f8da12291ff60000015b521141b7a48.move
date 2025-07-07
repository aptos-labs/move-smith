
//# publish
module 0xCAFE::QueueModule {
    // A simple generic queue implemented with vector and indices
    // to test FIFO order through enqueue and dequeue operations.

    use std::vector;

    // Add drop ability to Queue so it can be dropped safely (fixes error about drop)
    struct Queue<T: copy+drop> has store, drop {
        data: vector<T>,
        front: u64,
        back: u64,
    }

    public fun create_queue<T: copy+drop>(): Queue<T> {
        Queue {
            data: vector::empty<T>(),
            front: 0,
            back: 0,
        }
    }

    public fun enqueue<T: copy+drop>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.data, item);
        queue.back = queue.back + 1;
    }

    public fun dequeue<T: copy+drop>(queue: &mut Queue<T>): T {
        assert!(queue.front < queue.back, 1000);
        // To avoid dropping by implicit copy, consume the value by unpacking it here:
        // vector::borrow returns &T, we need a copy of T, so dereference works because T: copy
        let item = *vector::borrow(&queue.data, queue.front);
        queue.front = queue.front + 1;
        item
    }

    public fun size<T: copy+drop>(queue: &Queue<T>): u64 {
        queue.back - queue.front
    }

    public fun runner() {
        let q = create_queue<u64>();
        enqueue(&mut q, 101u64);
        enqueue(&mut q, 102u64);
        enqueue(&mut q, 103u64);
        let first = dequeue(&mut q);
        let second = dequeue(&mut q);
        let third = dequeue(&mut q);
        // no assertions, just exercise move compiler and VM
        let _sum = first + second + third;
    }
}



//# run 0xCAFE::QueueModule::runner




//# publish
module 0xCAFE::ReferenceStructs {
    // Testing variant and singleton structs with fields referencing other types

    struct Inner has copy, drop {
        val: u8,
    }

    struct Outer has copy, drop {
        inner_ref: Inner,
        number: u16,
    }

    // Add drop ability to enum SingleVariant (fixes drop error)
    enum SingleVariant has copy, drop {
        Variant1 { inner: Inner },
    }

    public fun create_inner(val: u8): Inner {
        Inner { val }
    }

    public fun create_outer(inner: Inner, n: u16): Outer {
        Outer {
            inner_ref: inner,
            number: n,
        }
    }

    public fun create_variant(inner: Inner): SingleVariant {
        SingleVariant::Variant1 { inner }
    }

    public fun runner() {
        let inr = create_inner(42u8);
        let out = create_outer(inr, 123u16);
        let sv = create_variant(inr);
        let _ = out.number;
        // To consume sv and avoid implicit drop error, do a match on sv
        match sv {
            SingleVariant::Variant1 { inner: _ } => (),
        };
        // no asserts, exercise struct referencing other struct types
    }
}



//# run 0xCAFE::ReferenceStructs::runner




//# publish
module 0xCAFE::MultiAbility {
    // Combine multiple abilities in a type parameter using '+' syntax

    struct Wrapper<T: copy+drop+store+key> has store, key {
        value: T,
    }

    public fun create_wrapper<T: copy+drop+store+key>(val: T): Wrapper<T> {
        Wrapper { value: val }
    }

    public fun runner() {
        // Use Wrapper<u64> and Wrapper<bool> - but u64 and bool do NOT have key ability.
        // Instead, use types that have the key ability, such as address or a struct with key.

        // Here we can use address type (has key) or define a new struct with key

        // Use address instead of u64
        let w1 = create_wrapper<address>(@0x1);
        // Use bool with wrapper is invalid, use bool wrapper without key instead
        // so remove w2 or replace with address bool wrap: we just remove w2 to fix compilation error

        let _ = w1.value;
        // let _ = w2.value; // removed due to error
    }
}



//# run 0xCAFE::MultiAbility::runner
