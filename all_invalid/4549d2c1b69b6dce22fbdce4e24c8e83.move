
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    // A singleton struct with a vector of u8 representing the queue
    struct Queue has key, store {
        items: vector<u8>
    }

    // Variant struct with fields referencing other types
    struct Container<T: copy+drop+store> has store {
        inner: T,
        queue: Queue,
    }

    /// Enqueue item to the queue
    public fun enqueue(q: &mut Queue, item: u8) {
        vector::push_back(&mut q.items, item);
    }

    /// Dequeue item from the queue
    /// Returns option: Some(item) if not empty, else None
    public fun dequeue(q: &mut Queue): 0xCAFE::Option::Option {
        let len = vector::length(&q.items);
        if (len == 0) {
            0xCAFE::Option::Option::None
        } else {
            let item = *vector::borrow(&q.items, 0);
            // shift left all items by removing the front one
            // We'll remove the first element by recreating vector without first element
            // But Move std does not provide direct remove at index, so do manual:
            // in this test, to not complicate, we swap last item with first then pop_back and reverse vector to fix order
            let last_idx = len - 1;
            if (last_idx > 0) {
                let last_val = *vector::borrow(&q.items, last_idx);
                *vector::borrow_mut(&mut q.items, 0) = last_val;
                vector::pop_back(&mut q.items);
                // reverse vector to restore order without the first element
                let i = 0;
                let j = vector::length(&q.items) - 1;
                while (i < j) {
                    let temp_i = *vector::borrow(&q.items, i);
                    let temp_j = *vector::borrow(&q.items, j);
                    *vector::borrow_mut(&mut q.items, i) = temp_j;
                    *vector::borrow_mut(&mut q.items, j) = temp_i;
                    i = i + 1;
                    j = j - 1;
                };
            } else {
                vector::pop_back(&mut q.items);
            };
            0xCAFE::Option::Option::Some(item)
        }
    }

    /// Run function that enqueues and dequeues multiple items to test FIFO order 
    public fun test_fifo(): bool {
        let q = Queue {items: vector::empty<u8>()};
        let items: vector<u8> = vector[1u8, 2u8, 3u8];
        let len = vector::length(&items);
        let i = 0;
        while (i < len) {
            let item = *vector::borrow(&items, i);
            enqueue(&mut q, item);
            i = i + 1;
        };
        let pass = true;
        let idx = 0;
        loop {
            let opt = dequeue(&mut q);
            match opt {
                0xCAFE::Option::Option::Some(val) => {
                    let expected = *vector::borrow(&items, idx);
                    if (val != expected) {
                        pass = false;
                    };
                    idx = idx + 1;
                },
                0xCAFE::Option::Option::None => {
                    break;
                }
            };
        };
        pass
    }
}

// To represent Option type since std Option isn't guaranteed here
// We define our own Option enum here



//# publish
module 0xCAFE::Option {
    enum Option has copy, drop {
        None,
        Some(u8),
    }
}




//# run 0xCAFE::QueueModule::test_fifo





//# publish
module 0xCAFE::DeprecatedModule {
    // Removed unused 'use std::signer;' import 
    // since no signer used in this module

    // deprecated = "old field, do not use"]
    struct OldStruct has store, key {
        val: u8,
    }

    // deprecated = "use NewStruct instead"]
    public fun deprecated_fun() {
        let x = 42u8;
        let y = x + 1;
    }

    struct NewStruct<T: copy+drop+store+key> has store, key {
        data: T,
        // Container with multiple abilities combined using '+'
        c: 0xCAFE::QueueModule::Container<T>,
    }

    public fun create_new_struct<T: copy+drop+store+key>(data: T, /*s: signer removed as unused*/) : NewStruct<T> {
        let queue = 0xCAFE::QueueModule::Queue {items: vector::empty<u8>()};
        NewStruct {data, c: 0xCAFE::QueueModule::Container {inner: data, queue}}
    }

    public fun modify_and_reassign(x: u8): u8 {
        let y = x;
        y = 10u8;
        y = y + 5u8;
        y
    }
}




//# run 0xCAFE::DeprecatedModule::deprecated_fun




//# run 0xCAFE::DeprecatedModule::modify_and_reassign --args 3u8
