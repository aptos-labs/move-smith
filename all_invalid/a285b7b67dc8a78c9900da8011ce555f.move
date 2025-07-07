address 0x1 {
module GenericValueTest {

    use std::vector;
    use std::option;

    /// A struct holding a generic value V and also a generic Move function from V to V.
    struct Holder<T, V> has key {
        value: V,
        func: fn(T): V, // function pointer with generics
    }

    /// A resource wrapping a vector of Holder<T, V> to test containers of generics.
    struct HolderList<T, V> has key {
        holders: vector<Holder<T, V>>,
    }

    /// An example struct with multiple fields, to test pattern bindings on complex structures.
    struct ComplexStruct<A, B> has copy, drop, store {
        a: A,
        b: B,
        nested: vector<u8>,
    }


    //////////////////////
    /// Sample generic functions
    //////////////////////

    /// Increase a u64 by 1
    public fun incr_u64(x: u64): u64 {
        x + 1
    }

    /// Reverses a vector<u8>
    public fun reverse_vec_u8(v: vector<u8>): vector<u8> {
        let len = vector::length(&v);
        let mut res = vector::empty<u8>();
        let mut i = 0;
        while (i < len) {
            vector::push_back(&mut res, *vector::borrow(&v, len - i - 1));
            i = i + 1;
        };
        res
    }

    /// Identity function for generic T
    public fun id<T>(x: T): T {
        x
    }


    /////////////////////////
    /// Initialize resource with generic holders
    /////////////////////////

    public fun init_holder_list_u64(account: &signer) {
        let h1 = Holder<u64, u64> {
            value: 42u64,
            func: incr_u64,
        };
        let h2 = Holder<u64, u64> {
            value: 100u64,
            func: incr_u64,
        };
        let holders = vector::empty<Holder<u64, u64>>();
        vector::push_back(&mut holders, h1);
        vector::push_back(&mut holders, h2);
        move_to(account, HolderList<u64, u64> { holders })
    }

    public fun init_holder_list_vec(account: &signer) {
        let v1 = vector::empty<u8>();
        vector::push_back(&mut {v1}, 1u8);
        vector::push_back(&mut {v1}, 2u8);
        vector::push_back(&mut {v1}, 3u8);

        let v2 = vector::empty<u8>();
        vector::push_back(&mut {v2}, 4u8);
        vector::push_back(&mut {v2}, 5u8);

        let h1 = Holder<vector<u8>, vector<u8>> {
            value: v1,
            func: reverse_vec_u8,
        };
        let h2 = Holder<vector<u8>, vector<u8>> {
            value: v2,
            func: reverse_vec_u8,
        };

        let mut holders = vector::empty<Holder<vector<u8>, vector<u8>>>();
        vector::push_back(&mut holders, h1);
        vector::push_back(&mut holders, h2);
        move_to(account, HolderList<vector<u8>, vector<u8>> { holders })
    }

    /////////////////////////
    /// Test retrieving, calling functions and pattern matching with pattern binding lists
    /////////////////////////

    public fun test_holder_list_u64(account: &signer) acquires HolderList {
        let holder_list = borrow_global<HolderList<u64, u64>>(signer::address_of(account));

        // Pattern matching with binding lists on vector
        // We pull the first and second Holder elements and match their internal structure in pattern binding lists
        let [holder1, holder2] = vector::borrow(&holder_list.holders, 0).copy();
        let h1_value = holder1.value;
        let h2_value = holder2.value;

        // Call functions stored inside holders on their values
        let h1_result = (holder1.func)(h1_value);
        let h2_result = (holder2.func)(h2_value);

        // Checks - simple asserts (using assert for test framework)
        assert!(h1_value == 42, 0);
        assert!(h1_result == 43, 1);
        assert!(h2_value == 100, 2);
        assert!(h2_result == 101, 3);
    }

    public fun test_holder_list_vec(account: &signer) acquires HolderList {
        let holder_list = borrow_global<HolderList<vector<u8>, vector<u8>>>(signer::address_of(account));

        // Pattern matching the vector of holders
        // We test destructuring vectors with pattern binding lists

        let holders_ref = &holder_list.holders;

        // Using pattern match on vector length and elements

        let len = vector::length(holders_ref);
        assert!(len == 2, 10);

        // Destructure the vector by pattern matching
        let [h1, h2] = [vector::borrow(holders_ref, 0), vector::borrow(holders_ref, 1)];

        // Now match on internal structure with pattern binding lists - bindings in each match arm

        let ComplexStructResult1 = {
            let val = &h1.value;
            let reversed = (h1.func)(*val);

            // Expect reversed vector to have elements in reverse order
            assert!(vector::length(&reversed) == vector::length(val), 20);

            reversed
        };

        let ComplexStructResult2 = {
            let val = &h2.value;
            let reversed = (h2.func)(*val);

            assert!(vector::length(&reversed) == vector::length(val), 21);

            reversed
        };

        // Asserts on reversed outputs: original v1 was [1,2,3], reversed is [3,2,1]
        assert!(vector::borrow(&ComplexStructResult1, 0) == 3, 30);
        assert!(vector::borrow(&ComplexStructResult1, 2) == 1, 31);

        // Original v2 was [4,5], reversed is [5,4]
        assert!(vector::borrow(&ComplexStructResult2, 0) == 5, 40);
        assert!(vector::borrow(&ComplexStructResult2, 1) == 4, 41);
    }

    /////////////////////////////
    /// A test function combining complex pattern binding lists
    /////////////////////////////

    /// A generic function returning a ComplexStruct
    public fun make_complex_struct<A: copy + drop + store, B: copy + drop + store>(
        a: A,
        b: B,
        nested: vector<u8>
    ): ComplexStruct<A, B> {
        ComplexStruct { a, b, nested }
    }


    /// Test pattern matching with pattern binding lists on ComplexStruct in a match expression
    public fun test_pattern_binding_list(account: &signer) {
        let nested_vec = vector::empty<u8>();
        vector::push_back(&mut nested_vec, 10);
        vector::push_back(&mut nested_vec, 20);
        vector::push_back(&mut nested_vec, 30);

        let cs = make_complex_struct(100u64, true, nested_vec);

        // Nested pattern match destructuring, pattern binding lists on struct fields
        match cs {
            ComplexStruct { a: a_val, b: b_val, nested: ref nested_list } => {
                // Match on nested list pattern binding list [10,20,30]
                let [first, second, third] = [
                    vector::borrow(nested_list, 0),
                    vector::borrow(nested_list, 1),
                    vector::borrow(nested_list, 2),
                ];

                assert!(*first == 10, 50);
                assert!(*second == 20, 51);
                assert!(*third == 30, 52);

                assert!(a_val == 100, 53);
                assert!(b_val == true, 54);
            }
        };
    }

    ////////////////////////////
    /// Transactional test entry point
    /////////////////////////////

    #[test_only]
    public fun transactional_test(account: &signer) acquires HolderList {
        // Create the generic holders for u64
        init_holder_list_u64(account);

        // Test them
        test_holder_list_u64(account);

        // Create generic holders for vector<u8>
        init_holder_list_vec(account);

        // Test vector<u8> holders + pattern matching
        test_holder_list_vec(account);

        // Test complex struct pattern binding lists
        test_pattern_binding_list(account);
    }
}
}

// Featurres:
// 0360f4b5cf74fca58cc71d4637178d07: Test that generic values—including function values with concrete generic types—can be stored, retrieved, and correctly matched for type equality in resources on-chain.
// 250ccbd7036b39252ecd52156bdafca9: Use pattern binding lists to match on complex structures in each match arm.
// 1e96113981612f1960e592423878d3f9: Declare and use type parameters in Move types, including as elements of containers and function arguments and returns
