//# publish
module 0xCAFE::InvariantTestModule {
    use std::signer;

    // Define a resource that will be subject to the global invariant
    struct Counter has key, store {
        value: u64,
    }

    // Initialize the resource at given address with value 0
    public fun init(s: signer) {
        let addr = signer::address_of(&s);
        move_to<Counter>(&s, Counter { value: 0 });
    }

    public fun increment(s: signer) {
        let addr = signer::address_of(&s);
        let counter_mut_ref = borrow_global_mut<Counter>(addr);
        counter_mut_ref.value = counter_mut_ref.value + 1;
    }

    public fun decrement(s: signer) {
        let addr = signer::address_of(&s);
        let counter_mut_ref = borrow_global_mut<Counter>(addr);
        // Prevent underflow; will abort if underflow would occur
        assert!(counter_mut_ref.value > 0, 1001);
        counter_mut_ref.value = counter_mut_ref.value - 1;
    }

    // A public function to read the current value
    public fun get_value(s: signer): u64 {
        let addr = signer::address_of(&s);
        let counter_ref = borrow_global<Counter>(addr);
        counter_ref.value
    }

    // Runner function to test invariant enforcement and basic ops
    public fun runner(s: signer) {
        init(s);
        increment(s);
        increment(s);
        decrement(s);
        let _v = get_value(s);
    }

    // Define global invariant to state value is never negative (u64 cannot be negative)
    // but can also ensure something like value less than some max (for demo)

    spec global invariant ForAll addr: address {
        let c = exists<Counter>(addr);
        implies c (
            borrow_global<Counter>(addr).value <= 10000
        )
    }
}

//# run 0xCAFE::InvariantTestModule::runner --signers 0xCAFEBABE

//# run 0xCAFE::InvariantTestModule::init --signers 0xDEADBEEF

//# run 0xCAFE::InvariantTestModule::increment --signers 0xDEADBEEF

//# run 0xCAFE::InvariantTestModule::get_value --signers 0xDEADBEEF

//# run 0xCAFE::InvariantTestModule::decrement --signers 0xDEADBEEF

//# run 0xCAFE::InvariantTestModule::get_value --signers 0xDEADBEEF

//# run 0xCAFE::InvariantTestModule::decrement --signers 0xDEADBEEF

//# run 0xCAFE::InvariantTestModule::get_value --signers 0xDEADBEEF

// Featurres:
// 11cd210cb22875e7781aba2a76b1f857: Define global invariants in your Move modules using specification conditions with the GlobalInvariant or GlobalInvariantUpdate kinds.
// f7f2352953dc3c35286e268ed8e08272: Avoid using restricted or reserved names for identifiers in your Move code
// 336076452978ed665784ddcf662dcede: Write tests for Move modules that are primary targets of compilation
