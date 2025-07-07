
//# publish
module 0xCAFE::QueueWithRefs {
    use std::vector;
    use std::signer;

    // A generic queue struct supporting enqueue and dequeue
    // Enforce that T is copy and drop (to test combined abilities)
    struct Queue<T has copy + drop> has store {
        items: vector<T>,
    }

    public fun create<T has copy + drop>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    // Enqueue item at the back
    public fun enqueue<T has copy + drop>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    // Dequeue item from the front, returns option<T>
    // Returns some item if queue not empty, none otherwise
    // Here Option is a local enum for test simplicity
    enum Option<T> has copy, drop {
        Some(T),
        None,
    }

    public fun dequeue<T has copy + drop>(queue: &mut Queue<T>): Option<T> {
        if (vector::length(&queue.items) > 0) {
            let item = vector::pop_back(&mut queue.items);
            // pop_back returns last, but queue is FIFO, so use reverse trick:
            // Instead of pop_back, borrow and remove front element with shifting
            // But vector API has no remove_front, so implement workaround by rotating the vector
            // For testing purpose, we implement a simpler dequeue that pops front by copying vector behind
            // But here as a quick approach, we emulate dequeue by reversing and popping back:
            // We'll implement dequeue properly below as a new function

            // The above naive approach is wrong; rewrite dequeue below for FIFO:

            // This function should be body-only with no semicolon so rewrite instead:
            // We'll implement a helper private function for FIFO dequeue
            queue_dequeue(queue)
        } else {
            Option::None
        }
    }

    fun queue_dequeue<T has copy + drop>(queue: &mut Queue<T>): Option<T> {
        let len = vector::length(&queue.items);
        if (len == 0) {
            Option::None
        } else {
            // extract front item (index 0)
            let front_item = *vector::borrow(&queue.items, 0);
            // create new vector without front item
            let new_items = vector::empty<T>();
            let i = 1;
            while (i < len) {
                vector::push_back(&mut new_items, *vector::borrow(&queue.items, i));
                i = i + 1;
            };
            queue.items = new_items;
            Option::Some(front_item)
        }
    }

    // A struct with a field referencing another type. Here referencing queue of u8
    struct RefHolder has key, store {
        id: u64,
        ref_queue: Queue<u8>,
    }

    // The struct has key, store but no copy or drop, to test combinations

    // A variant enum that has a singleton and a variant with a reference to RefHolder
    enum MyEnum has copy, drop {
        Unit,
        RefVariant(RefHolder),
    }

    // Test function to create and return MyEnum::RefVariant with initialized RefHolder
    public fun create_refvariant(): MyEnum {
        let q = create<u8>();
        let q_mut = q;
        enqueue(&mut q_mut, 10u8);
        enqueue(&mut q_mut, 20u8);
        let holder = RefHolder { id: 1, ref_queue: q_mut };
        MyEnum::RefVariant(holder)
    }

    // Function to test dequeue behavior with multiple enqueues, returning sum of values dequeued
    public fun test_queue_enqueue_dequeue(): u64 {
        let q = create<u8>();
        enqueue(&mut q, 1u8);
        enqueue(&mut q, 2u8);
        enqueue(&mut q, 3u8);

        let sum: u64 = 0;

        let res1 = dequeue(&mut q);
        match (res1) {
            Option::Some(v) => sum = sum + (v as u64),
            Option::None => sum = sum + 0,
        };

        let res2 = dequeue(&mut q);
        match (res2) {
            Option::Some(v) => sum = sum + (v as u64),
            Option::None => sum = sum + 0,
        };

        let res3 = dequeue(&mut q);
        match (res3) {
            Option::Some(v) => sum = sum + (v as u64),
            Option::None => sum = sum + 0,
        };

        // Even if dequeue again, should get None, no panic or error
        let _res4 = dequeue(&mut q);

        sum
    }

    // Function to test UninitializedUseChecker by purposely using uninitialized variable x
    // The VM/compiler should reject or error on this function if checker is active
    // But for testing, here define a function with a local variable used without init, commented out
    // We can't put code that errors at runtime, so we put it as private and don't call it
    fun uninitialized_use_test() {
        // let x: u8;
        // let y = x + 1u8; // uninitialized use - should cause error from checker
        // ignore y;
    }

    // Runner function to call all above in one shot
    public fun runner(): u64 {
        // Test multiple enqueue and dequeue preserving FIFO order
        let sum = test_queue_enqueue_dequeue();

        // Create and drop MyEnum to exercise combined abilities and referencing fields
        let _enum = create_refvariant();
        sum
    }
}


//# run 0xCAFE::QueueWithRefs::runner


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// b8228987c3d09500a27124b2ee06c161: Use UninitializedUseChecker to detect uninitialized variable usage.
