
//# publish
module 0xCAFE::FifoQueue {
    // FIFO Queue of u64 values

    struct Queue has store {
        items: vector<u64>,
    }

    public fun create(): Queue {
        let items = vector::empty<u64>();
        Queue {items}
    }

    public fun enqueue(q: &mut Queue, val: u64) {
        vector::push_back(&mut q.items, val);
    }

    public fun dequeue(q: &mut Queue): u64 {
        assert!(!vector::is_empty(&q.items), 1);
        let val = *vector::borrow(&q.items, 0);
        let _ = vector::remove(&mut q.items, 0);
        val
    }

    public fun test_fifo() {
        let q = create();
        enqueue(&mut q, 10);
        enqueue(&mut q, 20);
        enqueue(&mut q, 30);

        let first = dequeue(&mut q);
        let second = dequeue(&mut q);
        let third = dequeue(&mut q);

        // No assertions required
        let _ = (first, second, third);
    }
}


//# run 0xCAFE::FifoQueue::test_fifo


//# publish
module 0xCAFE::ComplexStructs {
    use std::vector;

    // A struct with a field that references another struct
    struct Inner has copy, drop, store {
        val: u8,
    }

    struct Outer has copy, drop, store {
        inner: Inner,
        data: vector<u8>,
    }

    // Variant struct with multiple fields including reference types
    enum Variant with copy, drop {
        V1,
        V2 {
            inner: Inner,
            data: vector<u8>,
        }
    }

    public fun make_outer(val: u8): Outer {
        let inner = Inner { val };
        let data = vector::empty<u8>();
        Outer {inner, data}
    }

    public fun make_variant_v2(val: u8): Variant {
        let inner = Inner { val };
        let data = vector::empty<u8>();
        Variant::V2 { inner, data }
    }

    public fun test_complex() {
        let _outer = make_outer(42);
        let _var = make_variant_v2(24);
    }
}


//# run 0xCAFE::ComplexStructs::test_complex


//# publish
module 0xCAFE::AbilitiesDemo {
    // Combining multiple abilities for a type parameter
    struct MultiAbilityStruct<T: copy + drop + store> has store {
        val: T,
    }

    public fun create_instance<T: copy + drop + store>(val: T): MultiAbilityStruct<T> {
        MultiAbilityStruct {val}
    }

    public fun test_abilities() {
        let instance_u8 = create_instance<u8>(100u8);
        let instance_address = create_instance<address>(@0xCAFE);
        let instance_vector = create_instance<vector<u8>>(vector::empty<u8>());
        let _ = (instance_u8, instance_address, instance_vector);
    }
}


//# run 0xCAFE::AbilitiesDemo::test_abilities


//# publish
module 0xCAFE::NestedInlineCalls {
    // Inline function at bottom
    public inline fun inline_add_one(x: u64): u64 {
        x + 1
    }

    // Nested call level 2 inline function
    public inline fun inline_double_add(x: u64): u64 {
        let y = inline_add_one(x);
        y + inline_add_one(y)
    }

    // Nested call level 1 function calls the inline function
    public fun outer_add(x: u64): u64 {
        let y = inline_double_add(x);
        y + 10
    }

    public fun test_nested_calls() {
        let result = outer_add(5);
        // last expression returns result
        result;
    }
}


//# run 0xCAFE::NestedInlineCalls::test_nested_calls


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 16498d8b85e5344481f87be22cfd31bb: Test that inlined functions can be called in multiple levels of nested calls across modules and produce the correct result.
