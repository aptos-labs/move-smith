
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::signer;

    // Define a generic queue struct with multiple abilities on T and multiple type params with + abilities
    struct Queue<T: copy+store+drop, U: copy+drop> has store {
        items: vector<T>,
        meta: U,
    }

    struct MetaInfo has drop {
        count: u64,
        flag: bool,
    }

    // Singleton struct containing a variant and some field referencing generic type
    enum State<T> has copy, drop {
        Empty,
        NonEmpty {
            front: T,
            length: u64,
        }
    }

    struct SingletonHolder<T> has key {
        id: u64,
        state: State<T>,
    }

    public fun init_queue<T: copy+store+drop, U: copy+drop>(count: u64, flag: bool): Queue<T, U> {
        let v = vector::empty<T>();
        let meta = MetaInfo {count, flag};
        Queue<T, U> {items: v, meta}
    }

    public fun enqueue<T: copy+store+drop, U: copy+drop>(q: &mut Queue<T, U>, item: T) {
        vector::push_back(&mut q.items, item);
        // Increment count in meta
        (q.meta).count = (q.meta).count + 1;
    }

    public fun dequeue<T: copy+store+drop, U: copy+drop>(q: &mut Queue<T, U>): Option<T> {
        if (vector::is_empty(&q.items)) {
            Option::none<T>()
        } else {
            let item = vector::remove(&mut q.items, 0);
            (q.meta).count = (q.meta).count - 1;
            Option::some<T>(item)
        }
    }

    // Instantiate SingletonHolder with some reference to T, test State variant usage
    public fun create_singleton<T: copy>(id: u64, front: T): SingletonHolder<T> {
        SingletonHolder<T> {
            id,
            state: State::NonEmpty {front, length: 1u64}
        }
    }

    // Define an inline function that accepts a lambda and calls with side effect expressions
    public fun exec_lambda_with_side_effects(f: |u8|u8, x: u8): u8 {
        let y = { let _a = x + 1u8; _a * 2u8 };
        f(y)
    }

    // Runner to test enqueue dequeue FIFO
    public fun test_fifo() {
        let q = init_queue<u8, MetaInfo>(0, true);
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let o1 = dequeue(&mut q);
        let o2 = dequeue(&mut q);
        let o3 = dequeue(&mut q);

        // Use values to avoid unused warnings
        match (o1) {
            Option::some(v) => { assert!(v == 10u8, 1); },
            Option::none() => {},
        };
        match (o2) {
            Option::some(v) => { assert!(v == 20u8, 2); },
            Option::none() => {},
        };
        match (o3) {
            Option::some(v) => { assert!(v == 30u8, 3); },
            Option::none() => {},
        };
    }

    // Runner to test singleton with variant state
    public fun test_singleton() {
        let s = create_singleton<u8>(42u64, 7u8);
        match (s.state) {
            State::NonEmpty {front, length} => {
                assert!(front == 7u8, 10);
                assert!(length == 1u64, 11);
            },
            State::Empty => {},
        };
    }

    // Runner to test lambda with side effects and sequencing
    public fun test_lambda() {
        let lambda: |u8|u8 has copy+drop = |a: u8| {
            let b = a + 1u8;
            b * 2u8
        };
        let res = exec_lambda_with_side_effects(lambda, 4u8);
        assert!(res == 22u8, 20); // ((4+1)*2)+1 * 2 = 22
    }
}



//# run 0xCAFE::QueueModule::test_fifo


//# run 0xCAFE::QueueModule::test_singleton


//# run 0xCAFE::QueueModule::test_lambda


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 5d06b27b54b8c9fe107c4b6c915e1ac6: Use the '<' token as an end delimiter in parsing contexts where nested '>>' tokens are involved.
// 10119718775e18d370fc1cd1b12b6ae7: Test that lambda expressions (anonymous functions) can be passed as arguments and invoked with expressions containing side effects and sequence blocks, ensuring correct evaluation order and value propagation.
