
//# publish
module 0xCAFE::AdvancedFIFO {
    use std::vector;
    use std::signer;

    // Struct representing a queue using a vector
    struct Queue<T> has store {
        items: vector<T>,
    }

    public fun create_queue<T>(): Queue<T> {
        Queue {items: vector::empty<T>()}
    }

    public fun enqueue<T>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T>(q: &mut Queue<T>): T acquires Queue {
        // Removes and returns the item at front, simulating FIFO
        let length = vector::length(&q.items);
        assert!(length > 0, 1);
        let front_item = *vector::borrow(&q.items, 0);
        // Shift all elements down by one by popping front repeatedly
        // Because Move vectors do not support pop_front, simulate by replacing front with last and popping last then reversing vector except last
        // But simpler to swap remove front by swapping with last then pop_back then restore order
        // Here, we do swap remove which breaks order, so instead we copy all except front to a new vector.
        let new_vec = vector::empty<T>();
        let i = 1;
        while (i < length) {
            let elem = *vector::borrow(&q.items, i);
            vector::push_back(&mut new_vec, elem);
            i = i + 1;
        };
        q.items = new_vec;
        front_item
    }

    public fun length<T>(q: &Queue<T>): u64 {
        (vector::length(&q.items) as u64)
    }

    public fun runner() {
        let q = create_queue<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);
        assert!(length(&q) == 3, 100);

        let a = dequeue(&mut q);
        let b = dequeue(&mut q);
        let c = dequeue(&mut q);
        let _ = (a, b, c);

        assert!(a == 10, 101);
        assert!(b == 20, 102);
        assert!(c == 30, 103);

        assert!(length(&q) == 0, 104);
    }

    // Singleton struct with a field referencing Queue<u8>
    struct SingleWithQueue has key {
        id: u64,
        queue: Queue<u8>,
    }

    public fun create_single(s: signer) {
        let q = create_queue<u8>();
        let single = SingleWithQueue { id: 7u64, queue: q };
        move_to<SingleWithQueue>(&s, single);
    }

    // Adds + abilities to type parameter T: copy+drop+store
    public fun add_items_to_single_queue<T: copy+drop+store>(s: &signer, item1: T, item2: T) {
        let addr = signer::address_of(&s);
        let single_ref = borrow_global_mut<SingleWithQueue>(addr);
        enqueue(&mut single_ref.queue, item1);
        enqueue(&mut single_ref.queue, item2);
    }

    public fun single_queue_length(s: &signer): u64 {
        let single_ref = borrow_global<SingleWithQueue>(signer::address_of(&s));
        length(&single_ref.queue)
    }

    // Unconditional jump example using loop and break label
    public fun jump_example(x: u8): u8 {
        let res = 0u8;
        loop {
            if (x > 10) {
                res = 1;
                break;
            };
            if (x == 10) {
                res = 2;
                break;
            };
            // simulating unconditional jump by continuing the loop to the top again
            break;
        };
        res
    }

    // Nested loops with break statements
    public fun nested_loops() {
        let outer = 0u8;
        let inner = 0u8;
        loop {
            outer = outer + 1;
            loop {
                inner = inner + 1;
                if (inner >= 3) {
                    break;
                };
            };
            inner = 0;
            if (outer >= 2) {
                break;
            };
        };
    }

    // Global resource with multiple abilities for type param T using '+'
    struct DataHolder<T: copy+drop+store> has store {
        val: T,
    }

    public fun create_data_holder<T: copy+drop+store>(s: signer, v: T) {
        let dh = DataHolder<T> { val: v };
        move_to<DataHolder<T>>(&s, dh);
    }

    // Conditional borrow and get value
    public fun conditional_access<T: copy+drop+store>(addr: address, get_mut: bool): T acquires DataHolder {
        if (get_mut) {
            let dh_mut = borrow_global_mut<DataHolder<T>>(addr);
            // mutate val for test
            dh_mut.val = dh_mut.val;
            dh_mut.val
        } else {
            let dh_ref = borrow_global<DataHolder<T>>(addr);
            dh_ref.val
        }
    }
}



//# run 0xCAFE::AdvancedFIFO::runner



//# run 0xCAFE::AdvancedFIFO::create_single --signers 0xFEED



//# run 0xCAFE::AdvancedFIFO::add_items_to_single_queue --signers 0xFEED --args 42u8 43u8



//# run 0xCAFE::AdvancedFIFO::single_queue_length --signers 0xFEED



//# run 0xCAFE::AdvancedFIFO::jump_example --args 11u8



//# run 0xCAFE::AdvancedFIFO::nested_loops



//# run 0xCAFE::AdvancedFIFO::create_data_holder --signers 0xABCD --args 55u8



//# run 0xCAFE::AdvancedFIFO::conditional_access --args 0xABCD false



//# run 0xCAFE::AdvancedFIFO::conditional_access --args 0xABCD true
