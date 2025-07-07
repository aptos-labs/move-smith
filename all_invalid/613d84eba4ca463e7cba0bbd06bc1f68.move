
//# publish
module 0xBADD::TestModule {
    use std::vector;
    use std::signer;
    use std::option;

    struct R has copy, drop, store {
        value: u64,
    }

    public fun init_resource(s: &signer) {
        let r = R { value: 42 };
        move_to<R>(s, r);
    }

    public fun acquire_resource_and_check(s: &signer) acquires R {
        let r_ref: &R = borrow_global<R>(signer::address_of(s));
        assert!(r_ref.value == 42, 999);
    }

    public fun mutate_resource(s: &signer) acquires R {
        let r_mut: &mut R = borrow_global_mut<R>(signer::address_of(s));
        r_mut.value = 100;
    }

    public fun release_resource(s: &signer) {
        let r: R = move_from<R>(signer::address_of(s));
        assert!(r.value == 100, 888);
    }

    public fun test_vectors() {
        // Create a vector of u8
        let vec1: vector<u8> = vector::empty();
        vector::push_back(&mut vec1, 3);
        vector::push_back(&mut vec1, 1);
        vector::push_back(&mut vec1, 2);

        // Clone and compare vectors
        let vec2: vector<u8> = vector::clone(&vec1);
        assert!(vector::byte_equal(&vec1, &vec2), 777);

        // Sort vector and verify
        vector::swap(&mut vec1, 1, 2);
        assert!(!vector::byte_equal(&vec1, &vec2), 776);

        vector::swap(&mut vec1, 1, 2); // bring back to original order
        vector::sort(&mut vec1);
        let expected: vector<u8> = vector::build_with(|v| {
            vector::push_back(v, 1);
            vector::push_back(v, 2);
            vector::push_back(v, 3);
        });
        assert!(vector::byte_equal(&vec1, &expected), 775);

        // Test comparison
        let cmp_result = vector::byte_compare(&vec1, &expected);
        assert!(cmp_result == 0, 774);

        // Mutate vector and test
        vector::push_back(&mut vec1, 5);
        assert!(vector::length(&vec1) == 4, 773);
        let last = vector::pop_back(&mut vec1);
        assert!(last == option::some(5), 772);
        assert!(vector::length(&vec1) == 3, 771);
    }
}


//# run 0xBADD::TestModule::init_resource --signers 0xC0DE

//# run 0xBADD::TestModule::acquire_resource_and_check --signers 0xC0DE

//# run 0xBADD::TestModule::mutate_resource --signers 0xC0DE

//# run 0xBADD::TestModule::release_resource --signers 0xC0DE

//# run 0xBADD::TestModule::test_vectors

// Featurres:
// 13ff7b1daf9f4f8018f2ca1ae9d1c505: Use a simple named address as an address specifier, like (SomeAddress).
// af2774a7f514f73b2dde75b7bfd877a7: Declare resource acquisition in a Move function using the 'acquires R' syntax.
// cf326f1cd75c6ca0a86006587068b21e: Test that copying, sorting, and comparing vectors with element equality and mutation work correctly.
