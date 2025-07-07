
//# publish
module 0xCAFE::FifoQueue {
    use std::vector;
    use std::option;

    // A generic queue struct with multiple ability constraints on T
    struct Queue<T: copy + drop + store> has store {
        items: vector<T>,
        start: u64, // index for dequeue
    }

    // Initialize an empty queue
    public fun new<T: copy + drop + store>(): Queue<T> {
        Queue {
            items: vector::empty<T>(),
            start: 0u64,
        }
    }

    // Enqueue item at the end (push_back)
    public fun enqueue<T: copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    // Dequeue item from the front, returns option to handle empty queue
    public fun dequeue<T: copy + drop + store>(q: &mut Queue<T>): option::Option<T> {
        if (q.start < vector::length(&q.items)) {
            let item = *vector::borrow(&q.items, q.start as u64);
            q.start = q.start + 1u64;
            // Optional: compact vector if too many dequeued, but omitted for simplicity
            option::some(item)
        } else {
            option::none()
        }
    }

    // A runner function that enqueues several u8 items, dequeues them and returns vector of dequeued u8
    public fun runner(): vector<u8> {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let res = vector::empty<u8>();
        let item_opt = dequeue(&mut q);
        while (option::is_some(&item_opt)) {
            let item = option::borrow(&item_opt);
            vector::push_back(&mut res, *item);
            item_opt = dequeue(&mut q);
        };
        res
    }
}



//# run 0xCAFE::FifoQueue::runner




//# publish
module 0xCAFE::CrossRefStructs {
    use std::string;

    // A struct that references another struct type field by type parameter, tests cross type referencing in fields
    struct InnerRef<T> has copy, drop, store {
        value: T,
    }

    // A singleton struct with a field referencing InnerRef<string::String>
    struct Singleton has key {
        inner: InnerRef<string::String>,
    }

    // A variant enum struct with multiple variants referencing different InnerRef types
    enum VarRef<T1, T2> has copy, drop {
        V1 { field1: InnerRef<T1> },
        V2 { field2: InnerRef<T2> },
    }

    // Initialize singleton with string content
    public fun init_singleton(s: string::String): Singleton {
        Singleton {
            inner: InnerRef<string::String> { value: s }
        }
    }

    // Create an instance of VarRef with V1 variant
    public fun make_varref_v1<T1, T2>(val1: T1, _val2: T2): VarRef<T1, T2> {
        VarRef::V1 {
            field1: InnerRef<T1> { value: val1 }
        }
    }

    // Create an instance of VarRef with V2 variant
    public fun make_varref_v2<T1, T2>(_val1: T1, val2: T2): VarRef<T1, T2> {
        VarRef::V2 {
            field2: InnerRef<T2> { value: val2 }
        }
    }

    // Runner that tests struct creation
    public fun runner(): bool {
        let s = string::utf8(b"hello");
        let _singleton = init_singleton(s);
        let _v1 = make_varref_v1<u8, bool>(5u8, true);
        let _v2 = make_varref_v2<u8, bool>(6u8, false);
        true
    }
}



//# run 0xCAFE::CrossRefStructs::runner




//# publish
module 0xCAFE::AbilitiesCombo {
    // Use a struct with combined abilities on type parameter T: copy + drop + store
    struct Wrapper<T: copy + drop + store> has store {
        inner: T,
    }

    // A function that requires T to have copy + drop and store abilities using combined abilities syntax
    public fun make_wrapper<T: copy + drop + store>(value: T): Wrapper<T> {
        Wrapper { inner: value }
    }

    // A runner function that tests ability combination with u8 (has copy+drop+store)
    public fun runner(): Wrapper<u8> {
        make_wrapper(42u8)
    }
}



//# run 0xCAFE::AbilitiesCombo::runner




//# publish
module 0xCAFE::LifetimeAnnotations {
    // Illustrate code-region-like annotations with comments for lifetimes (no actual syntax in Move language)

    struct S has copy, drop, store {
        val: u8,
    }

    // Although no lifetime syntax in Move, annotate code regions with comments to signify reference safety intent

    public fun operate_refs(s: &S): u8 {
        // begin lifetime 'outer_ref
        let x = s.val;
        {
            // begin lifetime 'inner_ref
            let r = &s.val;
            let y = *r;
            // end lifetime 'inner_ref
            y
        };
        // end lifetime 'outer_ref

        x
    }

    // Runner to test call
    public fun runner(): u8 {
        let s = S { val: 5u8 };
        operate_refs(&s)
    }
}



//# run 0xCAFE::LifetimeAnnotations::runner




//# publish
module 0xCAFE::UnnecessaryAcquires {
    use std::signer;

    struct R has store {
        val: u8,
    }

    // Function annotated to acquire R, but does not actually use it - triggers compiler error in real compile test
    public fun f_unneeded_acquire() acquires R {
        let dummy = 1u8;
        let _ = dummy;
    }

    // Correct function acquiring and moving R resource
    public fun f_needed_acquire(addr: address) acquires R {
        let r = move_from<R>(addr);
        let _ = r.val;
        move_to<R>(&signer::address_to_signer(addr), r);
    }

    // Runner to silence unused warning for f_needed_acquire (no real run here)
    public fun runner() {}
}



//# run 0xCAFE::UnnecessaryAcquires::runner
