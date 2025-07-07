
//# publish
module 0xNEAT::VectorAndAttributesTest {
    use std::vector;

    // Test attributes
    // test]
    public fun test_vector_operations_and_attributes() {
        // Construct vectors with parentheses.
        let v1: vector<u8> = vector::empty<u8>();
        let v2: vector<u8> = vector::fresh<u8>(2);
        let vec_literals = vector[0u8, 1u8, 2u8];

        // Push back elements into v1
        vector::push_back(&mut v1, 10);
        vector::push_back(&mut v1, 20);
        vector::push_back(&mut v1, 30);

        // Access elements
        let _elem0 = *vector::borrow(&v1, 0);
        let _elem1 = *vector::borrow(&v1, 1);
        let _elem2 = *vector::borrow(&v1, 2);

        // Replace with a new value
        let v1_mut = &mut v1;
        *vector::borrow_mut(v1_mut, 0) = 100;
        *vector::borrow_mut(v1_mut, 1) = 200;

        // Pop back
        let last = vector::pop_back(v1_mut);

        // Assert last is as expected
        assert!(last == 200, 999);

        // Create another vector with explicit size
        let v3: vector<u16> = vector::new(3);
        // Push elements
        vector::push_back(&mut v3, 1000);
        vector::push_back(&mut v3, 2000);
        vector::push_back(&mut v3, 3000);
        // Borrow and add
        let _sum0 = *vector::borrow(&v3, 0);
        let _sum1 = *vector::borrow(&v3, 1);
        let _sum2 = *vector::borrow(&v3, 2);

        // Build nested vector
        let nested: vector<vector<u8>> = vector[vector[1u8, 2u8], vector[3u8, 4u8]];

        // Create vector of addresses
        let addr_vec: vector<address> = vector[@0xAB, @0xCD];

        // Test vector with capacity
        let cap_vec: vector<bool> = vector::with_capacity(5);
        // Push bools
        vector::push_back(&mut vector::with_capacity(5), true);
        vector::push_back(&mut vector::with_capacity(5), false);

        // Borrow and assert
        assert!(*vector::borrow(&addr_vec, 0) == @0xAB, 222);
        assert!(*vector::borrow(&addr_vec, 1) == @0xCD, 222);
        // Done
        let _ = nested;
        let _ = cap_vec;
    }
}


//# run 0xNEAT::VectorAndAttributesTest::test_vector_operations_and_attributes


// Featurres:
// 1ec968b9866c644bfe28fd6c982f270e: Use numeric tokens to identify positional fields in Move code.
// 041592336dc733cbed8be719548559d4: Annotate functions or members with #[test] or #[test_only] attributes to mark them as test members.
// d7f3dba58bc17d0cdfda8948adcd7a5e: Construct vectors with `Vector` expressions.
