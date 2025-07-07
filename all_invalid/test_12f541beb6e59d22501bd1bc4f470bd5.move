//# publish
module 0xabc::resource_test {
    // Struct with mutable fields for incrementing
    struct Counter has drop {
        count: u64,
        total: u64,
    }

    // Function to increment 'count' and update 'total'
    public fun increment(counter: &mut Counter): u64 {
        counter.count = counter.count + 1;
        counter.total = counter.total + counter.count;
        counter.total
    }

    // Function to create, modify, and deconstruct a resource, then compute sum
    public fun test(): u64 {
        let mut c = Counter { count: 0, total: 0 };
        // Increment twice
        let _ = increment(&mut c);
        let _ = increment(&mut c);
        // Deconstruct resource into fields
        let Counter { count, total } = c;
        // Compute sum of fields
        count + total
    }
}

//# run 0xabc::resource_test::test

//# publish
module 0xabc::closure_trait_test {
    // Trait with a function pointer
    struct FuncTrait(|&u64| bool) has drop;

    // Function to test assigning and invoking a closure
    public fun test(): bool {
        // Assign a closure to the FuncTrait
        let func: FuncTrait = |x| *x % 2 == 0; // checks if even
        // Call the function with a test value
        assert!(func(&4));
        // Also test with an odd value
        let is_even = |x| *x % 2 == 0;
        is_even(&3)
    }
}

//# run 0xabc::closure_trait_test::test

//# publish
module 0xabc::cap_init_destruction {
    // Capabilities / Resources with different aliases
    struct CapAlpha has copy, store {
        owner: address
    }

    struct CapBeta has copy, store {
        owner: address
    }

    struct CapGamma has copy, store {
        owner: address
    }

    struct StorageHolder has key {
        cap_gamma: CapGamma
    }

    // Destroy function for CapBeta
    fun destroy_beta(beta: CapBeta) {
        let CapBeta { owner: _ } = beta;
        // CapBeta is destroyed when function ends
    }

    // Function to 'initialize' resources: moves CapGamma into storage and destroys CapBeta
    public fun init(signer: &signer): (CapAlpha, CapGamma) {
        let cap1 = CapAlpha { owner: signer.address() };
        let cap2 = CapBeta { owner: signer.address() };
        let cap3 = CapGamma { owner: signer.address() };
        // Store CapGamma in global storage
        move_to(signer, StorageHolder { cap_gamma: cap3 });
        // Destroy CapBeta
        destroy_beta(cap2);
        (cap1, cap3)
    }
}

//# run 0xabc::cap_init_destruction::init --args <signer_address>