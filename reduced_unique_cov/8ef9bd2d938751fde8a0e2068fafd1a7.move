
//# publish
module 0xCAFE::FIFOQueue {
    use std::signer;
    use std::vector;

    /// A generic queue using a vector for storage
    /// T can have abilities copy, drop, store to be able to be stored and manipulated
    // Added `key` ability here so Queue<T> can be moved and borrowed globally
    struct Queue<T: copy + drop + store + key> has store, key {
        items: vector<T>
    }

    /// Initialize a new empty queue and move it to the signer's account
    public fun init_queue<T: copy + drop + store + key>(s: signer) {
        let queue = Queue<T> { items: vector::empty<T>() };
        move_to<Queue<T>>(&s, queue);
    }

    /// Enqueue an item to the queue stored under signer's account
    public fun enqueue<T: copy + drop + store + key>(s: signer, item: T) {
        let queue_ref = borrow_global_mut<Queue<T>>(signer::address_of(&s));
        vector::push_back(&mut queue_ref.items, item);
    }

    /// Dequeue an item from the front of the queue stored under signer's account
    /// Aborts if queue is empty with code 1000
    public fun dequeue<T: copy + drop + store + key>(s: signer): T {
        let queue_ref = borrow_global_mut<Queue<T>>(signer::address_of(&s));
        assert!(vector::length(&queue_ref.items) > 0, 1000);
        vector::remove(&mut queue_ref.items, 0)
    }

    /// Return the length of the queue
    public fun length<T: copy + drop + store + key>(s: signer): u64 {
        let queue_ref = borrow_global<Queue<T>>(signer::address_of(&s));
        vector::length(&queue_ref.items)
    }

    /// Runner function to test enqueuing and dequeuing multiple u8 items
    public fun runner_fifo_test(s: signer) {
        init_queue<u8>(s);
        enqueue<u8>(s, 10u8);
        enqueue<u8>(s, 20u8);
        enqueue<u8>(s, 30u8);

        let first = dequeue<u8>(s);
        let second = dequeue<u8>(s);
        let third = dequeue<u8>(s);
        // Cannot assign tuple to a variable, assign each separately instead
        // dummy usage to avoid unused variable warnings:
        let _ = first;
        let _ = second;
        let _ = third;
    }
}



//# publish
module 0xCAFE::NestedStructs {
    /// Internal simple struct which will be referenced
    struct Inner has copy, drop, store {
        a: u8,
        b: u16,
    }

    /// Singleton struct with a field of type Inner - referencing another struct type
    struct Singleton has key {
        inner: Inner
    }

    /// Variant struct enum with one variant containing an Inner field to reference another type
    enum VariantEnum has copy, drop {
        V0,
        V1(Inner),
    }

    /// Public function to create and move Singleton with nested Inner to signer account
    public fun create_singleton(s: signer) {
        let inner = Inner {a: 1u8, b: 100u16};
        let singleton = Singleton {inner};
        move_to<Singleton>(&s, singleton);
    }

    /// Public function returning VariantEnum::V1 with Inner data
    public fun make_variant(): VariantEnum {
        VariantEnum::V1(Inner { a: 7u8, b: 777u16 })
    }
}



//# publish
module 0xCAFE::CombinedAbilities {
    /// Struct with generalized type parameter T which must have copy and drop abilities
    // Added key ability to Wrapper since move_to requires it
    struct Wrapper<T: copy + drop + key> has store, key {
        value: T
    }

    /// Function that creates a Wrapper for u64 and returns it
    public fun create_wrapper(x: u64): Wrapper<u64> {
        Wrapper<u64> { value: x }
    }

    /// Generic function with T requiring copy + drop + store abilities, returns T value after copying
    public fun copy_and_return<T: copy + drop + store>(x: T): T {
        copy x
    }

    /// Demonstration runner function using combined abilities for type param
    public fun runner(s: signer) {
        let wrapper = create_wrapper(42u64);
        let _copy = copy_and_return(wrapper.value);

        // Move wrapper struct to signer's account as exercise of store ability too
        move_to<Wrapper<u64>>(&s, wrapper);
    }
}



//# run 0xCAFE::FIFOQueue::runner_fifo_test --signers 0xDEAD



//# run 0xCAFE::NestedStructs::create_singleton --signers 0xB0BA



//# run 0xCAFE::NestedStructs::make_variant



//# run 0xCAFE::CombinedAbilities::runner --signers 0xF00D
