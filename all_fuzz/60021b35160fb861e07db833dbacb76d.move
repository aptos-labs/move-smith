
//# publish
module 0xCAFE::QueueTest {
    use std::vector;

    // A FIFO queue struct with generic item type T that must have copy, drop, store
    struct Queue<T: copy + drop + store> has store {
        items: vector<T>,
        head_index: u64,
    }

    // Initialize a new empty queue
    public fun new<T: copy + drop + store>(): Queue<T> {
        Queue {
            items: vector::empty<T>(),
            head_index: 0,
        }
    }

    // Enqueue an item into the queue (push_back)
    public fun enqueue<T: copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    // Dequeue an item from the queue in FIFO order.
    // Requires that there is at least one item.
    public fun dequeue<T: copy + drop + store>(q: &mut Queue<T>): T {
        let idx = q.head_index;
        let item = *vector::borrow(&q.items, idx);
        q.head_index = idx + 1;

        // Optional: cleanup if front items were dequeued to avoid unbounded vector growth
        if (q.head_index >= 10) {
            let new_items = vector::empty<T>();
            let len = vector::length(&q.items);
            let i = q.head_index;
            while (i < len) {
                vector::push_back(&mut new_items, *vector::borrow(&q.items, i));
                i = i + 1;
            };
            q.items = new_items;
            q.head_index = 0;
        };

        item
    }

    // Runner function to test enqueuing multiple u8 items and then dequeuing them
    public fun runner() {
        let q = new<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);

        // just to use variables and avoid unused warnings (no assertions as per instructions)
        let _ = a + b + c;

        // consume q properly by unpacking it (avoid implicit drop error)
        let Queue { items: _, head_index: _ } = q;
    }


    /////////////////////////
    // Struct with variant and references
    /////////////////////////

    // A struct containing a field referencing another struct type
    struct Container has store {
        s: S,
    }

    struct S has store {
        value: u64,
    }

    // A variant enum with a variant that contains a reference to Container
    enum Wrapper has store {
        None,
        Single(Container),
    }

    // Function creating and returning a Wrapper::Single with a Container referencing an S
    public fun make_wrapper(): Wrapper {
        let s = S {value: 42};
        let c = Container { s };
        Wrapper::Single(c)
    }


    /////////////////////////////
    // Generic struct with combined abilities using '+'
    /////////////////////////////

    // Generic struct with type parameter constrained by copy+drop+store
    struct MultiAbility<T: copy + drop + store> has store {
        value: T,
    }

    // A function demonstrating instantiating MultiAbility with u64 and accessing value
    public fun multi_ability_runner(): u64 {
        let ma = MultiAbility<u64> {value: 123u64};
        let v = ma.value;

        // consume ma properly by unpacking it to avoid implicit drop error
        let MultiAbility { value: _ } = ma;

        v
    }
}



//# run 0xCAFE::QueueTest::runner



//# run 0xCAFE::QueueTest::make_wrapper



//# run 0xCAFE::QueueTest::multi_ability_runner
