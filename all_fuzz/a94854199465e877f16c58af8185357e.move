
//# publish
module 0xCAFE::QueueWithReference {
    use std::vector;
    use std::option::{Self, Option, Some, None};

    struct Queue<T: copy + drop + store> has store {
        items: vector<T>,
        front: u64,
    }

    public fun new<T: copy + drop + store>(): Queue<T> {
        let items = vector::empty<T>();
        let front = 0u64;
        Queue { items, front }
    }

    public fun enqueue<T: copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T: copy + drop + store>(q: &mut Queue<T>): Option<T> {
        let len = vector::length(&q.items);
        if (q.front >= len) {
            None {}
        } else {
            // Get item at front
            let item_ref = vector::borrow(&q.items, q.front);
            let item = *item_ref;
            q.front = q.front + 1;
            // Optionally drop old items from front if front grows too large - skipped for simplicity
            Some { val: item }
        }
    }

    public fun run_example() {
        let q = Self::new<u8>();
        enqueue(&mut q, 1);
        enqueue(&mut q, 2);
        enqueue(&mut q, 3);

        let item1 = dequeue(&mut q);
        let item2 = dequeue(&mut q);
        let item3 = dequeue(&mut q);
        let item4 = dequeue(&mut q);
        // Results here: item1 = Some(1), item2 = Some(2), item3 = Some(3), item4 = None
    }
}

// Move does not allow free-standing struct declarations outside modules,
// so move RefWrapper inside a module. We'll put it in the same module to keep it simple.

//# publish
module 0xCAFE::RefWrapperModule {
    struct RefWrapper<T> has copy, drop {
        inner: T,
    }
}


//# publish
module 0xCAFE::ComplexStructs {
    use 0xCAFE::QueueWithReference;
    use 0xCAFE::RefWrapperModule;
    use std::vector;

    struct SingleRef<T: copy+drop+store> has store {
        single: RefWrapperModule::RefWrapper<T>,
    }

    struct MultiRef<T: copy+drop+store, U: copy+drop+store> has store {
        first: RefWrapperModule::RefWrapper<T>,
        second: RefWrapperModule::RefWrapper<U>,
        queue: QueueWithReference::Queue<T>,
    }

    // A function that creates and initializes these structs
    public fun new_single<T: copy+drop+store>(value: T): SingleRef<T> {
        SingleRef { single: RefWrapperModule::RefWrapper { inner: value } }
    }

    public fun new_multi<T: copy+drop+store, U: copy+drop+store>(v1: T, v2: U): MultiRef<T, U> {
        let q = QueueWithReference::new<T>();
        QueueWithReference::enqueue(&mut q, v1);
        MultiRef {
            first: RefWrapperModule::RefWrapper { inner: v1 },
            second: RefWrapperModule::RefWrapper { inner: v2 },
            queue: q
        }
    }

    public fun run_example() {
        let _s = new_single(42u8);
        let _m = new_multi(7u8, 100u16);
    }
}



//# publish
module 0xCAFE::AbilitiesCombination {
    struct Pair<A: copy + drop + store, B: store + copy + drop> has store {
        a: A,
        b: B,
    }

    public fun create_pair<A: copy + drop + store, B: store + copy + drop>(a: A, b: B): Pair<A, B> {
        Pair { a, b }
    }

    public fun run_example() {
        let pair = Self::create_pair(5u8, 10u64);
        // Consume pair to avoid drop without drop ability error:
        let Pair { a: _, b: _ } = pair;
    }
}




//# run 0xCAFE::QueueWithReference::run_example




//# run 0xCAFE::ComplexStructs::run_example




//# run 0xCAFE::AbilitiesCombination::run_example
