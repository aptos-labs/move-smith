
//# publish
module 0xCAFE::QueueTest {
    use std::vector;
    use std::signer;

    // 2: Variant struct with field referencing other types: Here T is generic resource/struct type with copy+store abilities.
    struct Queue<T: copy + store> has key {
        items: vector<T>,
    }

    // 3: Struct with combined abilities for a type parameter using '+' syntax
    struct Container<T: copy + drop + store> has store {
        item: T,
    }

    // 4: Nested struct referencing a resource with mutable and immutable borrows.
    struct NestedResource has store {
        val: u8,
    }

    struct Holder has store {
        inner: NestedResource,
    }

    // Create a new queue as `move` resource at the signer address
    public fun create_queue<T: copy + store>(s: signer) {
        let q = Queue<T> {items: vector::empty<T>()};
        move_to<Queue<T>>(&s, q);
    }

    // Enqueue item (adds to the end)
    public fun enqueue<T: copy + store>(s: signer, item: T) {
        let q_ref = borrow_global_mut<Queue<T>>(signer::address_of(&s));
        vector::push_back(&mut q_ref.items, item);
    }

    // Dequeue item (removes from front)
    public fun dequeue<T: copy + store>(s: signer): T acquires Queue {
        let q_ref = borrow_global_mut<Queue<T>>(signer::address_of(&s));
        assert!(!vector::is_empty(&q_ref.items), 1);
        let item = *vector::borrow(&q_ref.items, 0);
        vector::remove(&mut q_ref.items, 0);
        item
    }

    // 4: Test nested referencing - read immutable and modify mutable fields without conflict
    public fun nested_test(s: signer) {
        let nested = NestedResource {val: 10};
        let holder = Holder {inner: nested};
        move_to<Holder>(&s, holder);
        let holder_ref = borrow_global<Holder>(signer::address_of(&s));
        let _val_read: u8 = holder_ref.inner.val;
        let holder_mut_ref = borrow_global_mut<Holder>(signer::address_of(&s));
        holder_mut_ref.inner.val = 42;
    }

    // 6: Assignment to variables bound in patterns and detect assigned variables
    public fun assign_in_pattern() {
        let (mut a, mut b) = (1u8, 2u8);
        a = 10u8;
        b = 20u8;
        let (_x, y) = (3u8, 4u8);
        // y is assigned below
        let y = y + 1u8;
        let (p, q) = (5u8, 6u8);
        // no assignment to p,q
        let (r, mut s) = (7u8, 8u8);
        s = 9u8;
    }

    // 5: Spec block including pragma directives
    // spec]
    pragma(
        "test" = "value"
    );

    // spec]
    fun spec_example(): bool {
        true
    }

    // Runner to exercise queue enqueue/dequeue FIFO ordering with u8 items
    public fun run_queue_fifo_test(s: signer) {
        create_queue<u8>(copy s);
        enqueue<u8>(copy s, 10u8);
        enqueue<u8>(copy s, 20u8);
        enqueue<u8>(copy s, 30u8);

        let first = dequeue<u8>(copy s);
        let second = dequeue<u8>(copy s);
        let third = dequeue<u8>(copy s);
        // Consume returned values but do nothing with them
        let _ = first;
        let _ = second;
        let _ = third;
    }
}


//# run 0xCAFE::QueueTest::run_queue_fifo_test --signers 0xBEEF


//# run 0xCAFE::QueueTest::nested_test --signers 0xBEEF


//# run 0xCAFE::QueueTest::assign_in_pattern


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// ee6f8ac25bdd718f7f30665bcd7dff2c: Test that referencing immutable and mutable borrows of a resource with nested structs correctly allows reading their fields and updating mutable references without causing conflicts.
// c1f37f0ad4f80bbc9489d5bb0e018ba2: Declare spec pragmas using the 'pragma' keyword within spec blocks.
// 5fc7c03fb100cc78231369da3d433efb: Perform assignments to variables bound in patterns and have the compiler detect which variables are assigned (thus, potentially modified).
