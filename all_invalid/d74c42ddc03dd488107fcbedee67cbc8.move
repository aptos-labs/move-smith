//# publish
module 0xCAFE::GlobalResourceTest {
    use std::signer;
    use std::vector;

    struct Counter has store, key {
        count: u64,
    }

    // Create the Counter resource at signer's address with initial count 0
    public fun create_counter(s: signer) {
        let addr = signer::address_of(&s);
        let counter = Counter { count: 0 };
        move_to<Counter>(&s, counter);
    }

    // Borrow global Counter resource correctly
    public fun borrow_counter(s: signer): u64 {
        let addr = signer::address_of(&s);
        let counter_ref: &Counter = borrow_global<Counter>(addr);
        counter_ref.count
    }

    // Try to borrow a non-existing type to cause error (for testing error case)
    // This function purposely tries to borrow Counter as a different type causing failure
    // We simulate this by trying to borrow Counter as vector<u8>. This will fail at runtime.
    // This must be called in a managed transactional environment to see the abort.
    public fun illegal_borrow(s: signer) {
        let addr = signer::address_of(&s);
        // Unsafe cast simulation: Attempt to borrow Counter resource with wrong type
        // We can't do this directly, so only call borrow_global with wrong type,
        // which will abort. Here a dummy struct is used to induce error.
        struct Dummy has store {}
        let _dummy_ref: &Dummy = borrow_global<Dummy>(addr);
    }

    // Increment counter value by one repeatedly using a while loop
    public fun increment_loop(s: signer, times: u8) {
        let addr = signer::address_of(&s);
        let counter_mut_ref: &mut Counter = borrow_global_mut<Counter>(addr);
        let mut i = 0;
        while (i < times) {
            counter_mut_ref.count = counter_mut_ref.count + 1;
            i = i + 1;
        };
    }

    // Decrement counter value repeatedly using loop expression until zero
    public fun decrement_until_zero(s: signer) {
        let addr = signer::address_of(&s);
        let counter_mut_ref: &mut Counter = borrow_global_mut<Counter>(addr);
        loop {
            if (counter_mut_ref.count == 0) {
                break;
            };
            counter_mut_ref.count = counter_mut_ref.count - 1;
        };
    }

    //////////////////////////////////////////////////
    //////// Global Invariant using Spec /////////////
    //////////////////////////////////////////////////

    // Declare a spec-global invariant that Counter.count is always less than 1000
    // Move global invariants in spec are checked by Move prover and some runtime tools.

    spec module {
        // We declare the invariant on Counter resources globally
        global_invariant CounterInv(Counter c) {
            c.count < 1000
        }
    }

    // Function to increment counter by a delta value to test the global invariant
    // It will respect the invariant condition by checking
    public fun safe_increment(s: signer, delta: u64) {
        let addr = signer::address_of(&s);
        let counter_mut_ref: &mut Counter = borrow_global_mut<Counter>(addr);
        let new_count = counter_mut_ref.count + delta;

        // Dynamic check to uphold invariant (enforced by us)
        assert!(new_count < 1000, 1001);

        counter_mut_ref.count = new_count;
    }

    // Function that tries to update count breaking the invariant on purpose (for testing)
    public fun break_invariant(s: signer) {
        let addr = signer::address_of(&s);
        let counter_mut_ref: &mut Counter = borrow_global_mut<Counter>(addr);
        counter_mut_ref.count = 1000; // violate c.count < 1000
    }
}

//# run 0xCAFE::GlobalResourceTest::create_counter --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::borrow_counter --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::increment_loop --signers 0xABCD --args 10u8

//# run 0xCAFE::GlobalResourceTest::borrow_counter --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::decrement_until_zero --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::borrow_counter --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::safe_increment --signers 0xABCD --args 50u64

//# run 0xCAFE::GlobalResourceTest::borrow_counter --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::break_invariant --signers 0xABCD

//# run 0xCAFE::GlobalResourceTest::illegal_borrow --signers 0xABCD


// Featurres:
// d0c248a9b0e77930c642fc950af4bb9a: Test that borrowing a global resource with a matched type works correctly and causes an error when the type does not match.
// 9369e9d76834837f0b510cb847679e36: Create loops using 'while' and 'loop' expressions
// 11cd210cb22875e7781aba2a76b1f857: Define global invariants in your Move modules using specification conditions with the GlobalInvariant or GlobalInvariantUpdate kinds.
