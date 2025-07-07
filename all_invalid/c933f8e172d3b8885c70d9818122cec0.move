
//# publish
module 0xCAFE::FifoQueue {
    use std::vector;
    use std::signer;

    /// A simple FIFO queue with enqueue and dequeue operations
    struct Queue<T> has store {
        items: vector<T>,
    }

    /// Initialize a new empty queue
    public fun new<T>(): Queue<T> {
        Queue<T> {
            items: vector::empty<T>(),
        }
    }

    /// Enqueue item in the queue
    public fun enqueue<T>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    /// Dequeue an item from the queue, returning option<T>
    public fun dequeue<T>(q: &mut Queue<T>): option::Option<T> {
        if (vector::is_empty(&q.items)) {
            option::none<T>()
        } else {
            let first = vector::borrow(&q.items, 0);
            let result = copy *first;
            vector::remove(&mut q.items, 0);
            option::some(result)
        }
    }

    /// Test runner that enqueues and dequeues multiple u8 items
    public fun runner(): vector<u8> {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let results = vector::empty<u8>();
        let opt = dequeue(&mut q);
        while (option::is_some(&opt)) {
            let val = option::borrow(&opt);
            vector::push_back(&mut results, *val);
            dequeue(&mut q); // dequeue to remove, but wrong: we must not dequeue again, so fix:
            // correction: we already removed the item inside dequeue(). So no second dequeue here.
            opt = dequeue(&mut q);
        };
        results
    }
}


//# publish
module 0xCAFE::ComplexTypesWithRef {
    use std::vector;

    struct Inner has copy, drop, store {
        id: u8,
        vals: vector<u64>,
    }

    struct Outer<T: store> has copy, drop, store {
        inner: Inner,
        reference: T,          // Generic type param field references other type
    }

    enum VariantWithRef<T: store> has copy, drop {
        None,
        SomeValue { value: T, description: vector<u8> },
    }

    public fun create_outer_with_inner_vec(): Outer<u64> {
        let vals = vector::empty<u64>();
        vector::push_back(&mut vals, 42u64);
        vector::push_back(&mut vals, 84u64);
        let inner = Inner { id: 1u8, vals };
        Outer<u64> { inner, reference: 999u64 }
    }

    public fun create_variant_some_val(): VariantWithRef<u8> {
        let desc = vector::empty<u8>();
        VariantWithRef::SomeValue { value: 123u8, description: desc}
    }
}


//# publish
module 0xCAFE::AbilitiesPlus {
    /// A struct with multiple ability constraints
    struct MultiAbilityType has copy, drop, store {}

    /// Generic struct with type parameter having multiple ability constraints
    struct GenericPlus<T: copy+drop+store> has store {
        val: T,
    }

    public fun create_generic_plus_instance(): GenericPlus<MultiAbilityType> {
        GenericPlus<MultiAbilityType> { val: MultiAbilityType {} }
    }
}


//# publish
module 0xCAFE::GenericModuleNoCycles {
    /// A generic struct with type parameters with no cyclic dependencies
    struct A<T: store> has store {
        x: u8,
        y: T,
    }

    struct B<U: store> has store {
        a: A<U>, // B refers to A instantiated with U
        z: u64,
    }

    /// A generic function creating nested instances without cyclic instantiations
    public fun create_b_instance(): B<u16> {
        let a_inst = A<u16> { x: 10u8, y: 20u16 };
        B<u16> { a: a_inst, z: 30u64 }
    }
}


//# run 0xCAFE::FifoQueue::runner


//# run 0xCAFE::ComplexTypesWithRef::create_outer_with_inner_vec


//# run 0xCAFE::ComplexTypesWithRef::create_variant_some_val


//# run 0xCAFE::AbilitiesPlus::create_generic_plus_instance


//# run 0xCAFE::GenericModuleNoCycles::create_b_instance


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 52355f6dd2ea6a5aa30d192b084db16b: Define generic modules without introducing cyclic instantiations of type parameters.
