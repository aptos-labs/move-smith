
//# publish
module 0xCAFE::Queue {
    use std::vector;

    /// A generic FIFO queue with elements of type T that has copy + drop
    struct Queue<T: copy + drop> has store {
        data: vector<T>,
        front: u64, // index of the front element in the vector
        back: u64   // index one past the last element
    }

    public fun new<T: copy + drop>(): Queue<T> {
        Queue { data: vector::empty<T>(), front: 0, back: 0 }
    }

    public fun enqueue<T: copy + drop>(q: &mut Queue<T>, item: T) {
        // Push to the back of the vector
        if (q.back == 0xffff_ffff_ffff_ffff) {
            // Defensive: should never happen, but just in case reset indexes by copy data
            let new_data = vector::empty<T>();
            let length = q.back - q.front;
            let i = q.front;
            while (i < q.back) {
                vector::push_back(&mut new_data, *vector::borrow(&q.data, i));
                i = i + 1;
            };
            q.data = new_data;
            q.front = 0;
            q.back = length;
        };
        vector::push_back(&mut q.data, item);
        q.back = q.back + 1;
    }

    public fun dequeue<T: copy + drop>(q: &mut Queue<T>): T {
        assert!(q.front < q.back, 1);
        let item = *vector::borrow(&q.data, q.front);
        q.front = q.front + 1;
        item
    }

    /// Number of elements in the queue
    public fun size<T: copy + drop>(q: &Queue<T>): u64 {
        q.back - q.front
    }

    /// A runner function that enqueues 3 u8 values and dequeues them returning a vector<u8> in FIFO order
    public fun runner_fifo(): vector<u8> {
        let q = new<u8>();
        enqueue(&mut q, 10);
        enqueue(&mut q, 20);
        enqueue(&mut q, 30);

        let v = vector::empty<u8>();
        let x0 = dequeue(&mut q);
        v = vector::push_back(v, x0);
        let x1 = dequeue(&mut q);
        v = vector::push_back(v, x1);
        let x2 = dequeue(&mut q);
        v = vector::push_back(v, x2);
        v
    }

    /// A generic runner with a + b as input and outputs sum for testing multiple args comma-separated
    public fun runner_multi_args(a: u8, b: u8): u8 {
        a + b
    }

    /// A generic struct with multiple combined abilities type parameter
    struct MultiAbility<T: key + copy + drop> has store {
        val: T
    }

    /// Instantiate MultiAbility with address type to check combined constraint usage
    public fun use_multi_ability(): address {
        let m = MultiAbility<address>{ val: @0xCAFE };
        m.val
    }

    /// Example usage of generic type application with MultiAbility<u64>
    public fun use_generic_type(): u64 {
        let m = MultiAbility<u64>{ val: 42 };
        m.val
    }

    /// Examples of using '||' to create multiple alternatives on bool with || in if condition
    public fun boolean_alternatives(b1: bool, b2: bool): bool {
        if (b1 || b2) {
            true
        } else {
            false
        };
        // return true if at least one is true
        b1 || b2
    }

    /// Untyped integer literals default usage, sums 1 + 2 + 3 and returns u64
    public fun untyped_literals(): u64 {
        let a = 1;
        let b = 2;
        let c = 3;
        (a + b + c)
    }
}



//# run 0xCAFE::Queue::runner_fifo


//# run 0xCAFE::Queue::runner_multi_args --args 5u8 10u8


//# run 0xCAFE::Queue::use_multi_ability


//# run 0xCAFE::Queue::use_generic_type


//# run 0xCAFE::Queue::boolean_alternatives --args true false


//# run 0xCAFE::Queue::untyped_literals
