
//# publish
module 0xCAFE::ResourceAcquisition {
    use std::signer;

    struct Acquired has store, key {
        value: u64,
    }

    // Acquire resource, returns the stored value
    public fun acquire(s: signer, v: u64): u64 {
        let obj = Acquired { value: v };
        move_to<Acquired>(&s, obj);
        v
    }

    // Inline function that calls acquire, acquires resource via inline function call
    public inline fun inline_acquire(s: signer, v: u64): u64 {
        // Acquire resource using a helper function call (simulate nested call)
        nested_acquire(s, v)
    }

    // Helper function to be called inside inline_acquire
    fun nested_acquire(s: signer, v: u64): u64 {
        acquire(s, v)
    }

    // Function to check if resource exists at address and return its value, optional return 0 if none
    public fun check_value(addr: address): u64 {
        if (exists<Acquired>(addr)) {
            let ref = borrow_global<Acquired>(addr);
            ref.value
        } else {
            0
        }
    }
}


//# run 0xCAFE::ResourceAcquisition::inline_acquire --signers 0xB000 --args 42u64


//# run 0xCAFE::ResourceAcquisition::check_value --args 0xB000


//# publish
module 0xCAFE::QuantifiedExpressions {
    // Uses builtin forall and exists expressions to check values in range

    public fun forall_example(): bool {
        // For all x in 0..10, x < 20 (always true)
        let q = forall(x in 0..10, x < 20);
        q
    }

    public fun exists_example(): bool {
        // Exists x in 0..10 that equals 5 (true)
        let q = exists(x in 0..10, (x == 5));
        q
    }

    public fun forall_with_witness(): bool {
        // For all x in 0..10, there exists y in 10..20 such that y > x
        let q = forall(x in 0..10, exists(y in 10..20, y > x));
        q
    }

    public fun quantified_with_condition(): bool {
        // For all even x in 0..20, x + 2 > x (always true)
        let q = forall(x in 0..20, (x % 2 == 0), x + 2 > x);
        q
    }
}


//# run 0xCAFE::QuantifiedExpressions::forall_example


//# run 0xCAFE::QuantifiedExpressions::exists_example


//# run 0xCAFE::QuantifiedExpressions::forall_with_witness


//# run 0xCAFE::QuantifiedExpressions::quantified_with_condition



//# run
script {
    // Infinite loop to test out-of-gas error before any assertions
    loop {
        // Intentionally empty infinite loop
    };

    // Unreachable assertion (should never run)
    assert!(false, 999);
}


// Featurres:
// 57baad3637737b510be50aeb101099d1: Test that an inline function can call a function that acquires a resource, and the acquisition is properly propagated.
// 8c62fe7656b5a212416706b16db90891: Write quantified expressions (forall/exists) over variable bindings and ranges, optionally using witness/condition expressions.
// cec20a1c722c30352f8dbd8a196a7ccc: Test that an infinite loop in a script results in an out-of-gas error before reaching any assertions.
