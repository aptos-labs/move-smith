
//# publish
module 0xBADD::TestModule {
    use std::vector;
    use std::signer;
    use std::option;

    struct R has drop, store {
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
        let vec2: vector<u8> = vector::copy(&vec1);
        assert!(vector::equals(&vec1, &vec2), 777);

        // Swap and verify
        vector::swap(&mut vec1, 1, 2);
        assert!(!vector::equals(&vec1, &vec2), 776);

        // swap back
        vector::swap(&mut vec1, 1, 2);
        // Sort vector
        vector::sort(&mut vec1);
        let expected: vector<u8> = vector::empty();
        vector::push_back(&mut expected, 1);
        vector::push_back(&mut expected, 2);
        vector::push_back(&mut expected, 3);

        assert!(vector::equals(&vec1, &expected), 775);

        // Compare vectors
        let cmp_result: i64 = vector::compare(&vec1, &expected);
        assert!(cmp_result == 0, 774);

        // Mutate vector and test
        vector::push_back(&mut vec1, 5);
        assert!(vector::length(&vec1) == 4, 773);
        let last: option::Option<u8> = vector::pop_back(&mut vec1);
        assert!(option::is_some(&last) && option::extract(&last) == 5, 772);
        assert!(vector::length(&vec1) == 3, 771);
    }
}



//# run 0xBADD::TestModule::init_resource --signers 0xC0DE


//# run 0xBADD::TestModule::acquire_resource_and_check --signers 0xC0DE


//# run 0xBADD::TestModule::mutate_resource --signers 0xC0DE


//# run 0xBADD::TestModule::release_resource --signers 0xC0DE


//# run 0xBADD::TestModule::test_vectors