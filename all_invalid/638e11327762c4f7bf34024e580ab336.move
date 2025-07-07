
//# publish
module 0xCAFE::ComplexQueue {
    use std::vector;
    use std::signer;

    // Define a struct that will store some data to be queued
    struct Data has copy, drop, store {
        val: u64,
    }

    // Define a singleton struct with a field referencing another type
    struct SingletonWithRef has key, store {
        addr: address,
        data: Data,
    }

    // Define an enum variant with a field referencing another type
    enum VariantWithRef has copy, drop {
        Empty,
        Single(Data),
        Multiple(vector<Data>)
    }

    // A generic struct combining multiple abilities for its type parameter
    struct MultiAbilityHolder<T: copy+drop+store> has store {
        item: T,
    }

    // Queue struct: holds a vector for FIFO order
    struct Queue<T: copy+drop> has store {
        items: vector<T>,
    }

    public fun new_queue<T: copy+drop>(): Queue<T> {
        Queue { items: vector::empty<T>() }
    }

    public fun enqueue<T: copy+drop>(q: &mut Queue<T>, val: T) {
        vector::push_back(&mut q.items, val);
    }

    public fun dequeue<T: copy+drop>(q: &mut Queue<T>): T acquires Queue {
        assert!(!vector::is_empty(&q.items), 1);
        vector::remove(&mut q.items, 0)
    }

    // Inline function that accepts a code block and returns the computed u64 value
    public inline fun compute_with_block(x: u64, block: |u64|u64): u64 {
        // Apply the block to x and return the result
        block(x)
    }

    // Simple is_prime function for u64, uses naive approach for demonstration
    public fun is_prime(n: u64): bool {
        if (n <= 1) {
            false
        } else if (n == 2 || n == 3) {
            true
        } else if (n % 2 == 0) {
            false
        } else {
            let i = 3u64;
            while (i * i <= n) {
                if (n % i == 0) {
                    return false;
                };
                i = i + 2;
            };
            true
        }
    }

    // Runner function enqueuing multiple items and dequeuing them FIFO testing
    public fun fifo_test(): vector<u64> {
        let q = new_queue<Data>();
        enqueue(&mut q, Data { val: 10 });
        enqueue(&mut q, Data { val: 20 });
        enqueue(&mut q, Data { val: 30 });

        let d1 = dequeue(&mut q);
        let d2 = dequeue(&mut q);
        let d3 = dequeue(&mut q);

        vector::from_array([d1.val, d2.val, d3.val])
    }

    // Runner function testing the singleton and variant references
    public fun singleton_variant_test(s: signer) {
        let singleton = SingletonWithRef { addr: signer::address_of(&s), data: Data { val: 42 } };
        move_to<SingletonWithRef>(&s, singleton);

        let v1 = VariantWithRef::Empty;
        let v2 = VariantWithRef::Single(Data { val: 100 });
        let v3 = VariantWithRef::Multiple(vector::from_array([Data { val: 1 }, Data { val: 2 }]));

        let _copy_v2 = copy v2;
        let _copy_v3 = copy v3;
    }

    // Runner function testing MultiAbilityHolder with types satisfying copy+drop+store
    public fun multi_ability_holder_test(s: signer): u64 {
        let holder = MultiAbilityHolder<Data> { item: Data { val: 1234 } };
        move_to<MultiAbilityHolder<Data>>(&s, holder);
        let holder_ref = borrow_global<MultiAbilityHolder<Data>>(signer::address_of(&s));
        holder_ref.item.val
    }

    // Runner function testing compute_with_block with variable scoping and parameter passing
    public fun inline_block_test(): u64 {
        let y = 10;
        let result = compute_with_block(y, |x: u64| {
            let z = x * 2;
            z + 5
        });
        result
    }

    // Runner function testing the is_prime function on various values
    public fun is_prime_test(): vector<bool> {
        vector::from_array([
            is_prime(0),
            is_prime(1),
            is_prime(2),
            is_prime(3),
            is_prime(4),
            is_prime(5),
            is_prime(16),
            is_prime(17),
            is_prime(18),
            is_prime(19),
            is_prime(20),
            is_prime(23),
            is_prime(24),
            is_prime(97),
            is_prime(100),
        ])
    }
}


//# run 0xCAFE::ComplexQueue::fifo_test


//# run 0xCAFE::ComplexQueue::singleton_variant_test --signers 0xBEEF


//# run 0xCAFE::ComplexQueue::multi_ability_holder_test --signers 0xBEEF


//# run 0xCAFE::ComplexQueue::inline_block_test


//# run 0xCAFE::ComplexQueue::is_prime_test


// Featurres:
// 040973b25d5052b68cee91fb4cc86d03: Test that enqueuing multiple items and then dequeuing them retrieves the items in FIFO order.
// 246ec723997b3888a4b7d3ed0c806dc9: Add fields to singleton or variant structs with types that can reference other types
// 737a71b4ed3fdc6ad7df13e405873e73: Combine multiple abilities for a type parameter using the '+' syntax
// 2090fd4ad385c377de3ba20fc13c6f71: Verify that inline function arguments accepting code blocks correctly process variable scoping, parameter passing, and produce the expected computation result.
// 4076ee37cbaf26a4bb3047187e51c642: Test that the is_prime function correctly determines whether given u64 integers are prime numbers, including various edge cases.
