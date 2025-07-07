
//# publish
module 0xCAFE::QueueModule {
    use std::vector;

    // A queue struct with type parameter T with all abilities combined
    struct Queue<T: copy + drop + store> has store {
        items: vector<T>,
    }

    public fun create_queue<T: copy + drop + store>(): Queue<T> {
        let q = Queue<T> {items: vector::empty<T>()};
        q
    }

    public fun enqueue<T: copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    public fun dequeue<T: copy + drop + store>(q: &mut Queue<T>): T acquires Queue {
        assert!(!vector::is_empty(&q.items), 1);
        // remove index 0 shifts all elements to left
        let item_ref = vector::borrow(&q.items, 0);
        let ret = copy *item_ref;
        vector::remove(&mut q.items, 0);
        ret
    }

    // Function to get length
    public fun length<T: copy + drop + store>(q: &Queue<T>): u64 {
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
    struct Container<T: copy + drop> has store {
        value: T,
    }

    public fun create_container<T: copy + drop>(v: T): Container<T> {
        Container<T> {value: v}
    }

    public fun copy_value<T: copy + drop>(c: &Container<T>): T {
        copy c.value
    }
}



//# publish
module 0xCAFE::InstrSequenceModule {
    public fun calc_sum_and_product(a: u8, b: u8): (u8, u8) {
        let sum = a + b;
        let prod = a * b;
        let _diff = prod - sum; // renamed unused to _diff
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
        vector::for_each_mut(vec, |i| {
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
    use std::vector;

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
    use std::vector;

    fun main() {
        let v = ForEachMutTest::create_vector();
        ForEachMutTest::mutate_vector_elements(&mut v);
        // Let v be accessible for check
        let _ = vector::length(&v);
    }
}



//# run 0xCAFE::MinVersionModule::match_and_sum --args 0u8



//# run 0xCAFE::MinVersionModule::match_and_sum --args 2u8
