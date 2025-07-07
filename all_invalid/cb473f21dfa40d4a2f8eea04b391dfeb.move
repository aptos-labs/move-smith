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
        // Inline lambda to increment counter by 5
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
        let empty_vec: vector<u8> = vector[];
        // Lambda: takes &u8 returns u8 by adding 1
        let _mapped_vec = vector::map(&empty_vec, |item: &u8| { *item + 1u8 });
    }
}

//# run 0xCAFE::FunctionParamTest::apply_to_42

//# run 0xCAFE::FunctionParamTest::test_apply_increment --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::get_counter --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::reset_counter --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::get_counter --signers 0xBEEF

//# run 0xCAFE::FunctionParamTest::map_over_empty

// Featurres:
// 963ab02ce5f0914f7386f6d2ef6ed632: Test that functions accepting function parameters (like closures/lambdas) work correctly when passed inline anonymous functions.
// 737d190de5b6370dbe34480f2dfeb794: Use 'modifies' specifications to state which global resources a function can modify.
// 2a5422f316ef62fe7d9ca4c5e83b59c2: Test mapping over constant empty vectors with lambdas that use references and type annotations.
