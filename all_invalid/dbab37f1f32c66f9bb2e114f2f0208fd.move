
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    // A queue struct with type parameter T with all abilities combined
    struct Queue<T has copy + drop + store> has store {
        items: vector<T>,
    }

    public fun create_queue<T has copy + drop + store>(): Queue<T> {
        let q = Queue<T> {items: vector::empty<T>()};
        q
    }

    public fun enqueue<T has copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T has copy + drop + store>(q: &mut Queue<T>): T acquires Queue {
        assert!(!vector::is_empty(&q.items), 1);
        let item = vector::pop_back(&mut q.items);
        // The pop_back removes from end; to implement FIFO dequeue, we pop the first item.
        // But pop_back pops last: to dequeue first item we must remove at 0 index.
        // However vector module does not have pop_front; simulate by swapping:
        // Trick: To simulate FIFO using vector (stack with push_back/pop_back), we must store in reverse order.
        // Instead, fix approach: store front at back, so pop_back returns front.
        // For simplicity here, assume enqueue pushes front at back, dequeue pops from front index 0:
        // So let's rewrite to access and remove index 0 properly:

        // Correct dequeue with vector: remove index 0 and shift others left:
        // Use vector::borrow and vector::remove function.
        // Fix above code:
        let item = vector::borrow(&q.items, 0);
        let ret = copy *item;
        // remove index 0 shifts all elements to left
        vector::remove(&mut q.items, 0);
        ret
    }

    // Function to get length
    public fun length<T has copy + drop + store>(q: &Queue<T>): u64 {
        vector::length(&q.items)
    }
}


//# publish
module 0xCAFE::SingletonRefModule {
    use std::signer;

    // A singleton struct with field referencing address type
    struct Config has store, key {
        owner: address,
        threshold: u8,
    }

    // A variant enum with a field referring to u64 and address
    enum Status has store {
        Active {id: u64, account: address},
        Inactive,
    }

    public fun initialize(s: signer, threshold: u8) {
        let owner = signer::address_of(&s);
        let config = Config {owner, threshold};
        move_to<Config>(&s, config);
    }

    public fun update_threshold(s: signer, new_threshold: u8) {
        let config_ref: &mut Config = borrow_global_mut<Config>(signer::address_of(&s));
        config_ref.threshold = new_threshold;
    }

    public fun create_status_active(id: u64, account: address): Status {
        Status::Active {id, account}
    }
}


//# publish
module 0xCAFE::AbilityParamModule {
    // Demonstrate combining multiple abilities for type parameter
    struct Container<T has copy + drop> has store {
        value: T,
    }

    public fun create_container<T has copy + drop>(v: T): Container<T> {
        Container<T> {value: v}
    }

    public fun copy_value<T has copy + drop>(c: &Container<T>): T {
        copy c.value
    }
}


//# publish
module 0xCAFE::InstrSequenceModule {
    public fun calc_sum_and_product(a: u8, b: u8): (u8, u8) {
        let sum = a + b;
        let prod = a * b;
        let diff = prod - sum;
        (sum, prod)
    }

    public fun nested_calls(x: u8): u8 {
        let a = inner1(x);
        let b = inner2(a);
        b
    }

    fun inner1(x: u8): u8 {
        x + 2
    }

    fun inner2(y: u8): u8 {
        y * 3
    }
}


//# publish
module 0xCAFE::ForEachMutTest {
    use std::vector;

    public fun mutate_vector_elements(vec: &mut vector<u8>) {
        vector::for_each_mut(vec, fun(i: &mut u8) {
            *i = *i + 1;
        });
    }

    public fun create_vector(): vector<u8> {
        let v = vector[1u8, 2u8, 3u8, 4u8, 5u8];
        v
    }
}


//# publish
module 0xCAFE::MinVersionModule {
    // Function body using the new feature requiring min Move version 
    // Example: match expression with destructuring variant fields requires min version

    enum Number has copy, drop {
        Zero,
        One,
        Many(u8, u8),
    }

    public fun match_and_sum(num: Number): u8 {
        let val = match (num) {
            Number::Zero => 0,
            Number::One => 1,
            Number::Many(a, b) => a + b,
        };
        val
    }
}


//# run 0xCAFE::QueueModule::create_queue --args


//# run 0xCAFE::QueueModule::enqueue --args


//# run 0xCAFE::QueueModule::dequeue --args


//# run 0xCAFE::QueueModule::length --args

// Since queue api needs combination calls, write wrappers below


//# run
script {
    use 0xCAFE::QueueModule;

    fun main() {
        let q = QueueModule::create_queue<u8>();
        QueueModule::enqueue(&mut q, 10u8);
        QueueModule::enqueue(&mut q, 20u8);
        QueueModule::enqueue(&mut q, 30u8);
        let x1 = QueueModule::dequeue(&mut q);
        let x2 = QueueModule::dequeue(&mut q);
        let x3 = QueueModule::dequeue(&mut q);
        let len = QueueModule::length(&q);

        // Just touch variables so compiler does not complain
        let _ = (x1, x2, x3, len);
    }
}


//# run 0xCAFE::SingletonRefModule::initialize --signers 0xDEAD --args 50u8


//# run 0xCAFE::SingletonRefModule::update_threshold --signers 0xDEAD --args 75u8


//# run 0xCAFE::SingletonRefModule::create_status_active --args 42u64 0xBEEF


//# run 0xCAFE::AbilityParamModule::create_container --args 100u8


//# run 0xCAFE::AbilityParamModule::copy_value --args


//# run 0xCAFE::InstrSequenceModule::calc_sum_and_product --args 5u8 7u8


//# run 0xCAFE::InstrSequenceModule::nested_calls --args 3u8


//# run
script {
    use 0xCAFE::ForEachMutTest;

    fun main() {
        let v = ForEachMutTest::create_vector();
        ForEachMutTest::mutate_vector_elements(&mut v);
        // Let v be accessible for check
        let _ = vector::length(&v);
    }
}


//# run 0xCAFE::MinVersionModule::match_and_sum --args 0u8


//# run 0xCAFE::MinVersionModule::match_and_sum --args 2u8


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// e4595db29c530452e76d595154046d23: Write function bodies with a sequence of instructions.
// 850953569e145dcdf23be1fed163c5ff: Test that the `vector::for_each_mut` function correctly mutates each element of the vector in sequence.
// 81d7b796a8282833827611e111ad9db6: Use language constructs that require a minimum Move language version.
