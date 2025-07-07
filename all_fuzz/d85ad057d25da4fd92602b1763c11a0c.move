
//# publish
module 0xCAFE::FilterTest {
    use std::signer;

    // Struct to use with global storage and borrowing test
    struct Counter has store, key {
        val: u64,
    }

    // Increment function: increments the given mutable reference to u64 by 1
    public fun inc(x: &mut u64) {
        *x = *x + 1;
    }

    // Test function: creates a mutable local u64, increments it multiple times, and returns sum of values
    public fun test(): u64 {
        let cnt = 0u64;
        inc(&mut cnt);
        inc(&mut cnt);
        // after two increments cnt = 2
        let val1 = cnt;
        inc(&mut cnt);
        let val2 = cnt;
        val1 + val2
    }

    // Store Counter resource at the signer's address with initial value val
    public fun store_counter(s: signer, val: u64) {
        let counter = Counter { val };
        move_to<Counter>(&s, counter);
    }

    // Borrow global Counter resource mutably and increment its val field
    public fun inc_global_counter(s: signer) {
        let counter_ref: &mut Counter = borrow_global_mut<Counter>(signer::address_of(&s));
        inc(&mut counter_ref.val);
    }

    // Returns current val of Counter resource at signer's address
    public fun get_counter_val(s: signer): u64 {
        let counter_ref: &Counter = borrow_global<Counter>(signer::address_of(&s));
        counter_ref.val
    }

    // Attempt to borrow Counter resource but with wrong type u64 (should fail)
    public fun borrow_with_wrong_type(s: signer): u64 {
        // Intentionally cause type mismatch error by trying to borrow u64 as a global resource
        // This should fail at runtime because u64 is not a resource type
        // We write code that will compile, but fail at runtime.
        borrow_global<u64>(signer::address_of(&s))
    }
}


//# run 0xCAFE::FilterTest::inc


//# run 0xCAFE::FilterTest::test


//# run 0xCAFE::FilterTest::store_counter --signers 0xBABA --args 10u64


//# run 0xCAFE::FilterTest::get_counter_val --signers 0xBABA


//# run 0xCAFE::FilterTest::inc_global_counter --signers 0xBABA


//# run 0xCAFE::FilterTest::get_counter_val --signers 0xBABA


//# run 0xCAFE::FilterTest::borrow_with_wrong_type --signers 0xBABA


// Featurres:
// d2dee3b6c3fd10b775b2a0089f2736ab: Utilize the filtering mechanism to remove specification (spec) blocks associated with module members that have been filtered out of the module.
// 582bf6f000eedd329d50a0617d87039d: Test that the `inc` function correctly increments a mutable reference to a u64 and that the `test` function computes the expected combined value using multiple increments.
// d0c248a9b0e77930c642fc950af4bb9a: Test that borrowing a global resource with a matched type works correctly and causes an error when the type does not match.
