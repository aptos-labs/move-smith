
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::signer;

    // Define a struct Queue with generic type T that must have copy and store abilities
    struct Queue<T: copy + store> has store {
        items: vector<T>,
    }

    // Initialize an empty queue
    public fun create_queue<T: copy + store>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    // Enqueue an item
    public fun enqueue<T: copy + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    // Dequeue an item, return option type (simulate option as tuple (bool, T))
    public fun dequeue<T: copy + store>(q: &mut Queue<T>): (bool, T) {
        if (vector::length(&q.items) == 0) {
            // No item, return (false, dummy value)
            (false, *vector::borrow(&q.items, 0))
        } else {
            let item = vector::pop_back(&mut q.items);
            (true, item)
        }
    }

    // A singleton struct with a variant that holds another generic type with multiple abilities using '+' syntax
    struct RefHolder<T: copy + drop + store> has store {
        inner: T,
    }

    // A variant enum holding bool or a struct with a reference to inner type
    enum Holder<T: copy + drop + store> has copy, drop {
        BoolVariant(bool),
        RefVariant { field: RefHolder<T> },
    }

    // Function to test sequential assignments and arithmetic with mutable variable
    public fun sequential_assignment(mut_x: u8): u8 {
        let a = mut_x;
        a = a + 1;
        a = a * 2;
        a
    }

    // Function that modifies local variables using mutable reference and another function call
    public fun modify_and_use_ref(x: &mut u8) {
        *x = *x + 10;
        Self::helper(*x);
    }

    fun helper(val: u8) {
        let _ = val * 2;
    }

    // Test FIFO order with enqueue and dequeue
    public fun test_queue_fifo() {
        let q = create_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        // Dequeue should return first pushed since we will dequeue_front

        let first = vector::borrow(&q.items, 0);
        let second = vector::borrow(&q.items, 1);
        let third = vector::borrow(&q.items, 2);

        // Dummy fix for FIFO by dequeue_front function:
    }

    // dequeue front helper function updates the vector removing first element and returns it
    public fun dequeue_front<T: copy + store>(q: &mut Queue<T>): (bool, T) {
        if (vector::length(&q.items) == 0) {
            // To avoid borrowing an empty vector, instantiate a dummy value if possible
            // But since we cannot create a dummy T, return false paired with dummy value borrow
            (false, *vector::borrow(&q.items, 0))
        } else {
            let first = *vector::borrow(&q.items, 0);
            let new_vec = vector::empty<T>();
            let len = vector::length(&q.items);
            let i = 1;
            while (i < len) {
                vector::push_back(&mut new_vec, *vector::borrow(&q.items, i));
                i = i + 1;
            };
            q.items = new_vec;
            (true, first)
        }
    }

    // Runner function to test FIFO enqueue then dequeue_front
    public fun runner_fifo_test() {
        let q = create_queue<u8>();
        enqueue(&mut q, 1u8);
        enqueue(&mut q, 2u8);
        enqueue(&mut q, 3u8);

        let (ok1, v1) = dequeue_front(&mut q);
        let (ok2, v2) = dequeue_front(&mut q);
        let (ok3, v3) = dequeue_front(&mut q);

        // Use sequential assignment and mutable ref helper
        let res = sequential_assignment(4u8);

        // Need a mutable u8 variable for modify_and_use_ref
        let val = 5u8;
        modify_and_use_ref(&mut val);

        // Instantiate RefHolder and enum to verify combined ability usage
        let ref_obj = RefHolder<u8> { inner: 42u8 };
        let _enum_obj = Holder::RefVariant { field: ref_obj };
    }

    spec module {
        // axiom condition terminates with semicolon
        axiom true;
    }
}



//# run 0xCAFE::QueueModule::runner_fifo_test
