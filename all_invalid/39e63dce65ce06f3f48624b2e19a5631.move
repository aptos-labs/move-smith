
//# publish
module 0xCAFE::QueueModule {
    use std::signer;

    struct Queue<T: copy+drop> has store {
        items: vector<T>,
        head: u64,
    }

    public fun create_queue<T: copy+drop>(): Queue<T> {
        Queue { items: vector[], head: 0 }
    }

    public fun enqueue<T: copy+drop>(queue: &mut Queue<T>, item: T) {
        vector::push_back(&mut queue.items, item);
    }

    public fun dequeue<T: copy+drop>(queue: &mut Queue<T>): T {
        assert!(queue.head < vector::length(&queue.items), 1000);
        let item = *vector::borrow(&queue.items, queue.head as u64);
        queue.head = queue.head + 1;
        item
    }

    public fun length<T: copy+drop>(queue: &Queue<T>): u64 {
        vector::length(&queue.items) - queue.head
    }

    // A runner that enqueues multiple elements and dequeues them to return the sum
    public fun runner(): u64 {
        let queue = create_queue<u64>();
        enqueue(&mut queue, 10);
        enqueue(&mut queue, 20);
        enqueue(&mut queue, 30);

        let a = dequeue(&mut queue);
        let b = dequeue(&mut queue);
        let c = dequeue(&mut queue);

        a + b + c
    }
}


//# run 0xCAFE::QueueModule::runner


//# publish
module 0xCAFE::ComplexTypes {
    use std::option;

    // A singleton struct referencing QueueModule.Queue
    struct Wrapper has store {
        queue: 0xCAFE::QueueModule::Queue<u64>,
    }

    // Variant enum with a field that references Wrapper
    enum Container has copy, drop {
        Empty,
        Single(Wrapper),
        Pair { first: Wrapper, second: Wrapper },
    }

    public fun create_wrapper(): Wrapper {
        let queue = 0xCAFE::QueueModule::create_queue<u64>();
        Wrapper { queue }
    }

    public fun create_container_single(): Container {
        let wrapper = create_wrapper();
        Container::Single(wrapper)
    }

    public fun create_container_pair(): Container {
        let w1 = create_wrapper();
        let w2 = create_wrapper();
        Container::Pair { first: w1, second: w2 }
    }

    public fun use_container(c: Container): u64 {
        match (c) {
            Container::Empty => 0,
            Container::Single(wrapper) => {
                0xCAFE::QueueModule::length(&wrapper.queue)
            },
            Container::Pair { first, second } => {
                0xCAFE::QueueModule::length(&first.queue) + 0xCAFE::QueueModule::length(&second.queue)
            },
        }
    }
}


//# run 0xCAFE::ComplexTypes::use_container --args 0xCAFE::ComplexTypes::create_container_single()


//# run 0xCAFE::ComplexTypes::use_container --args 0xCAFE::ComplexTypes::create_container_pair()


//# publish
module 0xCAFE::AbilitiesTest {
    // Type parameter requires both copy and drop ability
    public struct DualAbility<T: copy+drop> has store { 
        value: T
    }

    public fun create_dual_ability<T: copy+drop>(v: T): DualAbility<T> {
        DualAbility { value: v }
    }

    public fun extract_value<T: copy+drop>(d: DualAbility<T>): T {
        d.value
    }

    // Runner to validate creation and extraction
    public fun runner(): u64 {
        let d = create_dual_ability(42u64);
        extract_value(d)
    }
}


//# run 0xCAFE::AbilitiesTest::runner


//# publish
module 0xCAFE::OperatorTest {
    public fun precedence_test(): u64 {
        let a = 3u64 + 2u64 * 5u64; // multiplication before addition: 3 + (2*5) = 13
        let b = (3u64 + 2u64) * 5u64; // (3+2)*5 = 25
        let c = a + b * 2u64; // 13 + 25*2 = 13 + 50 = 63
        c
    }
}


//# run 0xCAFE::OperatorTest::precedence_test


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 57919bd46e68fd73db04e28e80162320: Use binary operators with correct precedence during expression parsing.
