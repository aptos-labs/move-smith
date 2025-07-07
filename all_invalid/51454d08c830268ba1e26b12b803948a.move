//# publish
module 0xCAFE::FunctionParamTest {
    use std::vector;
    use std::signer;

    struct Counter has key, store {
        value: u64,
    }

    public fun init_counter(account: signer) acquires Counter {
        move_to(&account, Counter { value: 0 });
    }

    public fun get_counter(account: &signer): u64 acquires Counter {
        let counter_ref = borrow_global<Counter>(signer::address_of(account));
        counter_ref.value
    }

    public fun increment_counter(account: &signer, delta: u64) acquires Counter {
        let counter_mut_ref = borrow_global_mut<Counter>(signer::address_of(account));
        counter_mut_ref.value = counter_mut_ref.value + delta;
    }

    // Function that accepts a lambda that takes u64 and returns u64
    public fun apply_to_42(func: |u64|u64): u64 {
        func(42)
    }

    public fun test_apply_increment(account: signer) acquires Counter {
        init_counter(account);
        // Inline lambda to increment by 5
        let incrementer = |x: u64| { x + 5 };
        let val = apply_to_42(incrementer);
        increment_counter(&account, val);
    }

    // Function with modifies specification on Counter at signer address
    public fun reset_counter(account: signer) acquires Counter {
        let counter_mut_ref = borrow_global_mut<Counter>(signer::address_of(&account));
        counter_mut_ref.value = 0;
    }

    // Map over empty constant vector with a lambda using references and type annotations
    public fun map_over_empty() {
        let empty_vec: vector<u8> = vector::empty<u8>();
        // vector::map expects vector<u8>, so pass empty_vec (not &empty_vec)
        // Lambda: takes &u8 returns u8 by adding 1
        let _mapped_vec = vector::map(empty_vec, |item: &u8| { *item + 1u8 });
    }
}

//# run 0xCAFE::FunctionParamTest::apply_to_42

//# run 0xCAFE::FunctionParamTest::test_apply_increment --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::get_counter --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::reset_counter --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::get_counter --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::map_over_empty