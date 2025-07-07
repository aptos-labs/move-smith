
//# publish
module 0xCAFE::QueueModule {
    use std::vector;
    use std::option::{Self, Option};

    // A generic Queue struct with abilities Copy, Drop, Store to support Move semantics
    struct Queue<T> has store {
        items: vector<T>
    }

    // Enqueue an item to the queue
    public fun enqueue<T: copy + drop + store>(q: &mut Queue<T>, item: T) {
        vector::push_back(&mut q.items, item);
    }

    // Dequeue an item from the queue, returning option<T>
    public fun dequeue<T: copy + drop + store>(q: &mut Queue<T>): Option<T> {
        if (vector::is_empty(&q.items)) {
            Option::none<T>()
        } else {
            let front = *vector::borrow(&q.items, 0);
            vector::remove(&mut q.items, 0);
            Option::some(front)
        }
    }

    // Constructor for an empty Queue
    public fun empty<T: copy + drop + store>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    // Test function to enqueue and dequeue multiple u8 items and output last dequeued item
    public fun fifo_test(): u8 {
        let q = empty<u8>();
        enqueue(&mut q, 10u8);
        enqueue(&mut q, 20u8);
        enqueue(&mut q, 30u8);

        let _ = dequeue(&mut q);
        let _ = dequeue(&mut q);
        let last = dequeue(&mut q);
        let res = match last {
            Option::some(value) => value,
            Option::none() => 0u8
        };
        res
    }
}



//# run 0xCAFE::QueueModule::fifo_test




//# publish
module 0xCAFE::RecursiveChecker {
    use std::option::{Self, Option};

    // Recursive struct which nests itself in an Option variant
    struct Rec has store {
        val: u64,
        next: Option<Rec>
    }

    // Recursive Checker that counts how many nested Rec items are there up to max_depth = 10
    public fun count_depth(r: &Rec): u64 {
        count_depth_internal(r, 0)
    }

    fun count_depth_internal(r: &Rec, depth: u64): u64 {
        if (depth >= 10) {
            depth
        } else {
            match &r.next {
                Option::none() => depth + 1,
                Option::some(next_r) => count_depth_internal(next_r, depth + 1),
            }
        }
    }

    // Construct a Rec structure with a depth of 5 and return depth counted
    public fun run_checker(): u64 {
        let r5 = Rec { val: 5, next: Option::none<Rec>() };
        let r4 = Rec { val: 4, next: Option::some(r5) };
        let r3 = Rec { val: 3, next: Option::some(r4) };
        let r2 = Rec { val: 2, next: Option::some(r3) };
        let r1 = Rec { val: 1, next: Option::some(r2) };

        count_depth(&r1)
    }
}



//# run 0xCAFE::RecursiveChecker::run_checker




//# publish
module 0xCAFE::VariantRefModule {
    // Removed unused import std::signer as per errors

    // Variant enum that has types with references to other types and multiple abilities
    // Note: references cannot be stored in struct fields or enum variant fields.
    // To fix the error, we must remove the reference type or use something else such as store ownership.
    // We'll replace &B with B (ownership) to fix the error.

    enum Container<A: store, B: copy + drop + store> has store {
        Variant1,
        Variant2(A),
        Variant3 { a: A, b: B }
    }

    // Store a singleton struct with a field referencing another struct instance
    struct Singleton<A: store, B: copy + drop + store> has key {
        container: Container<A, B>
    }

    public fun create_singleton<A: store, B: copy + drop + store>(s: signer, a: A, b: B) {
        let cont = Container::Variant3 { a, b };
        let singleton = Singleton { container: cont };
        move_to<Singleton<A, B>>(&s, singleton);
    }

    public fun borrow_singleton<A: store, B: copy + drop + store>(addr: address): &Singleton<A, B> {
        borrow_global<Singleton<A, B>>(addr)
    }
}



//# publish
module 0xCAFE::AbilitiesTester {
    // Combines multiple abilities for a generic type parameter using '+'
    struct MultiAbilityType<T: copy + drop + store> has copy, drop, store {
        val: T
    }

    public fun create<T: copy + drop + store>(x: T): MultiAbilityType<T> {
        MultiAbilityType { val: x }
    }

    public fun get_value<T: copy + drop + store>(m: &MultiAbilityType<T>): &T {
        &m.val
    }
}



//# run 0xCAFE::AbilitiesTester::create --args 42u8



//# run 0xCAFE::AbilitiesTester::get_value --args 42u8
