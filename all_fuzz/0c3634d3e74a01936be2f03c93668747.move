
//# publish
module 0xCAFE::Adder {
    public fun add_then_return_fixed(a: u8, b: u8): u8 {
        let _sum = a + b;
        // ignore sum result for returning fixed value 42
        42u8
    }

    public fun inline_increment(x: u8): u8 {
        x + 1
    }

    public fun lambda_example(x: u8): u8 {
        let lambda: |u8|u8 has copy+drop = |n: u8| { n * 2 };
        lambda(x)
    }
}



//# publish
module 0xCAFE::NestedCalls {
    use 0xCAFE::Adder;

    public fun call_inline_increment_and_add(x: u8, y: u8): u8 {
        let incremented = Adder::inline_increment(x);
        Adder::add_then_return_fixed(incremented, y)
    }
}



//# publish
module 0xCAFE::CounterMap {
    use std::vector;
    use std::signer;
    use std::option;

    struct Counter has key, store {
        count: u64,
    }

    // Use a global resource table in account storage, simple singleton pattern
    struct CounterHolder has key, store {
        counters: vector<(address, Counter)>,
    }

    public fun init_counter_holder(s: &signer) {
        if (!exists<CounterHolder>(signer::address_of(s))) {
            let h = CounterHolder { counters: vector::empty<(address, Counter)>() };
            move_to(s, h);
        };
    }

    // Helper function to find mutable counter by address, returning Option<u64>
    fun find_counter_index(counters: &vector<(address, Counter)>, addr: address): option::Option<u64> {
        let length = vector::length(counters);
        let i = 0;
        while (i < length) {
            let (a, _) = *vector::borrow(counters, i);
            if (a == addr) {
                return option::some(i);
            };
            i = i + 1;
        };
        option::none()
    }

    public fun increment_counter(s: &signer): u64 {
        let addr = signer::address_of(s);
        let holder = borrow_global_mut<CounterHolder>(addr);
        let idx_opt = find_counter_index(&holder.counters, addr);
        if (option::is_some(&idx_opt)) {
            let idx = option::extract(idx_opt);
            let pair_ref = vector::borrow_mut(&mut holder.counters, idx);
            let (_addr_ref, counter_ref) = pair_ref;
            counter_ref.count = counter_ref.count + 1;
            counter_ref.count
        } else {
            // Initialize with count 1 if missing
            let new_counter = Counter { count: 1 };
            vector::push_back(&mut holder.counters, (addr, new_counter));
            1
        }
    }
}



//# run 0xCAFE::Adder::add_then_return_fixed --args 10u8 20u8



//# run 0xCAFE::Adder::lambda_example --args 7u8



//# run 0xCAFE::NestedCalls::call_inline_increment_and_add --args 5u8 3u8



//# run 0xCAFE::CounterMap::init_counter_holder --signers 0xD00D



//# run 0xCAFE::CounterMap::increment_counter --signers 0xD00D



//# run 0xCAFE::CounterMap::increment_counter --signers 0xD00D
