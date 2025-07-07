
//# publish
module 0xCAFE::QueueTest {
    use std::vector;
    use std::option;

    // Define a simple queue struct with a generic type parameter T having abilities copy+drop+store
    struct Queue<T: copy + drop + store> has store {
        items: vector<T>,
    }

    // Initialize an empty queue
    public fun new<T: copy + drop + store>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    // Enqueue an item (adds to back)
    public fun enqueue<T: copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    // Dequeue an item (removes from front), returns Option<T> - here emulate using vector length check
    public fun dequeue<T: copy + drop + store>(q: &mut Queue<T>): option::Option<T> {
        if (vector::is_empty(&q.items)) {
            option::none<T>()
        } else {
            let item = *vector::borrow(&q.items, 0);
            let len = vector::length(&q.items);
            // Prepare new vector without front item to replace old vector
            let new_items = vector::empty<T>();
            let i = 1;
            while (i < len) {
                let v = *vector::borrow(&q.items, i);
                vector::push_back(&mut new_items, v);
                i = i + 1;
            };
            q.items = new_items;
            option::some(item)
        }
    }

    // Function to enqueue multiple items then dequeue all to validate FIFO
    public fun test_fifo(): vector<u8> {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let res = vector::empty<u8>();
        let deq = dequeue(&mut q);
        while (option::is_some(&deq)) {
            let v = option::borrow(&deq);
            vector::push_back(&mut res, *v);
            deq = dequeue(&mut q);
        };
        res
    }

    // A variant struct with fields referencing other types, including references
    struct RefFieldStruct has store {
        data: vector<u8>,
        ref_to_data: &vector<u8>,
    }

    // Return an instance with these fields to test field referencing
    public fun create_ref_struct(): RefFieldStruct {
        let data = b"fields";
        let ref_to_data = &data;
        RefFieldStruct { data, ref_to_data }
    }

    // Struct with type parameter constrained by copy+drop+store to test multiple abilities
    struct MultipleAbilities<T: copy + drop + store> has store {
        val: T
    }

    // Testing unused type parameters, define struct with T unused and dummy func
    struct UnusedParam<T> has copy, drop {}

    public fun no_reach_code(x: u8): u8 {
        if (x > 10) {
            x
        } else {
            // 'no' usage to mark code definitely not reached - simulate with unreachable by abort
            // Since Move does not have `no`, we simulate with abort unreachable
            abort 999;
        };
        // This line is unreachable, but put semicolon so function is valid
    }

    // A dummy runner for no_reach_code that triggers abort intentionally (should abort)
    // This is to check unreachable `no`-like behavior, so no run call for this to prevent abort.
}



//# run 0xCAFE::QueueTest::test_fifo



//# run 0xCAFE::QueueTest::create_ref_struct



//# run 0xCAFE::QueueTest::no_reach_code --args 15u8




//# publish
module 0xCAFE::DefaultAddressModule {
    // This module tests publishing with default / specified address.

    // Simple struct only at module top level
    struct Example has copy, drop {}

    public fun dummy() {
        let _ = Example {};
    }
}



//# run 0xCAFE::DefaultAddressModule::dummy
