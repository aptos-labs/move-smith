
//# publish
module 0xCAFE::SpecTest {
    use std::signer;

    struct Counter has store, key {
        value: u64,
    }

    public fun initialize(s: signer) {
        let counter = Counter { value: 0u64 };
        move_to<Counter>(&s, counter);
    }

    public fun increment(s: signer) {
        let counter_ref = borrow_global_mut<Counter>(signer::address_of(&s));
        counter_ref.value = counter_ref.value + 1;
    }

    public fun get_value(s: signer): u64 {
        let counter_ref = borrow_global<Counter>(signer::address_of(&s));
        counter_ref.value
    }

    // Spec function to check if value is even
    spec fun is_even(value: u64): bool {
        value % 2 == 0
    }

    // Module-level spec block
    spec module {
        // Invariant: For all Counter resources under any address, the value is <= 100
        invariant forall addr: address where exists<Counter>(addr) {
            let c = borrow_global<Counter>(addr);
            c.value <= 100
        };
    }
}


//# run 0xCAFE::SpecTest::initialize --signers 0xDEAD


//# run 0xCAFE::SpecTest::increment --signers 0xDEAD


//# run 0xCAFE::SpecTest::increment --signers 0xDEAD


//# run 0xCAFE::SpecTest::get_value --signers 0xDEAD


// Featurres:
// 0b6f2742d8864af5077463340b1d65fc: Define specification functions (spec fun) to encapsulate logic used in specifications and verification conditions.
// c416dc1d62155276b1f629b93409bf9d: Declare module-level spec blocks with the 'module' target.
// 15d85e9a204608b4c1e8625f72ee3c04: Specify an expression for the invariant condition in a spec block.
