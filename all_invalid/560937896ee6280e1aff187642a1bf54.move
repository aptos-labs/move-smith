// File: transactional_test.move

//--- Test 1: Unnecessary "acquires" annotations detection

//# publish
module 0xCAFE::UnnecessaryAcquires {
    struct S has key, store {}

    // Function declares "acquires S" but does not actually access S. The compiler should allow omitting acquires.
    // We remove the acquires clause to test the compiler's inference.
    public entry fun test_no_acquire(_x: &u8) {
        // S is never accessed →
        let _ = *_x;
    }

    // This function does acquire S, so must declare acquires.
    public entry fun test_with_acquire(account: &signer) acquires S {
        move_from<S>(signer::address_of(account));
    }
}

//# run 0xCAFE::UnnecessaryAcquires::test_no_acquire --signers 0xCAFE

//# run 0xCAFE::UnnecessaryAcquires::test_with_acquire --signers 0xCAFE


//--- Test 2: vector operation error (index out of bounds) with #[expected_failure(vector_error)]

//# publish
module 0xBEEF::VectorFailure {
    use std::vector;
    use std::signer;
    
    // Runner function that will fail.
    #[expected_failure(vector_error, 1)] // minor status code 1 = OUT_OF_BOUND_INDEX
    public entry fun runner() {
        let v = vector::empty<u8>();
        // This will fail because the vector is empty.
        let _b = *vector::borrow(&v, 0);
    }
}

//# run 0xBEEF::VectorFailure::runner --signers 0xBEEF



//--- Test 3: Explicit Type Constraints with Abilities

//# publish
module 0xABCD::HasAbilities {
    use std::vector;

    // A generic struct that only accepts types with the 'copy' and 'drop' abilities.
    struct Container<T: +copy +drop> has store, drop {
        item: T,
    }

    // Function that works on T with +copy +drop
    public fun wrap<T: +copy +drop>(x: T): Container<T> {
        Container { item: x }
    }

    // Runner function with u64, which has both +copy and +drop.
    public entry fun runner() {
        let c = Self::wrap<u64>(123);
        // Just some operation to avoid unused variable warning.
        let _ = c.item;
    }
}

//# run 0xABCD::HasAbilities::runner --signers 0xABCD

// Now, test that wrap will not compile for types WITHOUT copy and drop abilities.
// Real "negative" tests would go into compiler suites, but in transactional test we only include compilable code.