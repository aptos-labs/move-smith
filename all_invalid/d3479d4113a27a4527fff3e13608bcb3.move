
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::option;

    // Define a generic queue struct with multiple abilities on T and multiple type params with + abilities
    struct Queue<T: copy+store+drop, U: copy+store+drop> has store {
        items: vector<T>,
        meta: U,
    }

    struct MetaInfo has copy + store + drop {
        count: u64,
        flag: bool,
    }

    // Singleton struct containing a variant and some field referencing generic type
    enum State<T> has copy + store + drop {
        Empty,
        NonEmpty {
            front: T,
            length: u64,
        }
    }

    struct SingletonHolder<T: copy + store> has key {
        id: u64,
        state: State<T>,
    }

    public fun init_queue<T: copy+store+drop, U: copy+store+drop>(count: u64, flag: bool): Queue<T, U> {
        let v = vector::empty<T>();
        let meta = MetaInfo {count, flag};
        Queue<T, U> {items: v, meta}
    }

    public fun enqueue<T: copy+store+drop, U: copy+store+drop>(q: &mut Queue<T, U>, item: T) {
        vector::push_back(&mut q.items, item);
        // Increment count in meta
        (q.meta).count = (q.meta).count + 1;
    }

    public fun dequeue<T: copy+store+drop, U: copy+store+drop>(q: &mut Queue<T, U>): option::Option<T> {
        if (vector::is_empty(&q.items)) {
            option::none<T>()
        } else {
            let item = vector::remove(&mut q.items, 0);
            (q.meta).count = (q.meta).count - 1;
            option::some<T>(item)
        }
    }

    // Instantiate SingletonHolder with some reference to T, test State variant usage
    public fun create_singleton<T: copy + store>(id: u64, front: T): SingletonHolder<T> {
        SingletonHolder<T> {
            id,
            state: State::NonEmpty {front, length: 1u64}
        }
    }

    // Define an inline function that accepts a lambda and calls with side effect expressions
    public fun exec_lambda_with_side_effects(f: &fun(u8): u8, x: u8): u8 {
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
        match o1 {
            option::some(v) => { assert!(v == 10u8, 1); },
            option::none => {},
        };
        match o2 {
            option::some(v) => { assert!(v == 20u8, 2); },
            option::none => {},
        };
        match o3 {
            option::some(v) => { assert!(v == 30u8, 3); },
            option::none => {},
        };
    }

    // Runner to test singleton with variant state
    public fun test_singleton() {
        let s = create_singleton<u8>(42u64, 7u8);
        match s.state {
            State::NonEmpty {front, length} => {
                assert!(front == 7u8, 10);
                assert!(length == 1u64, 11);
            },
            State::Empty => {},
        };
    }

    // Runner to test lambda with side effects and sequencing
    public fun test_lambda() {
        let lambda = fun(a: u8): u8 {
            let b = a + 1u8;
            b * 2u8
        };
        let res = exec_lambda_with_side_effects(&lambda, 4u8);
        assert!(res == 22u8, 20); // ((4+1)*2 + 1)* 2 = 22
    }
}




//# run 0xCAFE::QueueModule::test_fifo




//# run 0xCAFE::QueueModule::test_singleton




//# run 0xCAFE::QueueModule::test_lambda
