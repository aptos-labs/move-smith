
//# publish
module 0xCAFE::Queue {
    use std::vector;

    struct Queue<T: copy + drop> has store {
        items: vector<T>
    }

    public fun new<T: copy + drop>(): Queue<T> {
        Queue {
            items: vector::empty<T>()
        }
    }

    public fun enqueue<T: copy + drop>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T: copy + drop>(q: &mut Queue<T>): T {
        let first = *vector::borrow(&q.items, 0);
        vector::remove(&mut q.items, 0);
        first
    }

    // Runner function tests FIFO order by enqueueing 3 u8 items and dequeueing them in order.
    public fun runner_fifo() {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);

        // no asserts just run to cover behavior
        let _ = a + b + c;
    }
}


//# run 0xCAFE::Queue::runner_fifo


//# publish
module 0xCAFE::ComplexStructs {
    use std::vector;

    struct Inner<T> has copy, drop, store {
        val: T
    }

    struct Outer has copy, drop, store {
        inner: Inner<u64>,
        nums: vector<u8>,
    }

    // A variant struct with a field that references another type
    enum Wrapper has copy, drop {
        Variant1 { o: Outer },
        Variant2 { i: Inner<bool> }
    }

    public fun new_outer(): Outer {
        Outer {
            inner: Inner { val: 42u64 },
            nums: vector[1u8, 2u8, 3u8]
        }
    }

    public fun new_wrapper1(): Wrapper {
        Wrapper::Variant1 { o: new_outer() }
    }

    public fun new_wrapper2(): Wrapper {
        Wrapper::Variant2 { i: Inner { val: true } }
    }
}


//# run 0xCAFE::ComplexStructs::new_outer


//# run 0xCAFE::ComplexStructs::new_wrapper1


//# run 0xCAFE::ComplexStructs::new_wrapper2


//# publish
module 0xCAFE::AbilityCombine {
    // Combine copy+drop+store abilities in type parameter
    struct Complex<T: copy + drop + store> has store {
        val: T
    }

    public fun create_complex_copy(a: u8): Complex<u8> {
        Complex { val: a }
    }

    // also create a function that requires multiple abilities in type param and do something simple
    public fun requires_all_abilities<T: copy + drop + store>(t: T): T {
        t
    }
}


//# run 0xCAFE::AbilityCombine::create_complex_copy --args 7u8


//# run 0xCAFE::AbilityCombine::requires_all_abilities --args 123u8


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
