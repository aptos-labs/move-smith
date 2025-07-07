
//# publish
module 0xDEAD::ShadowingAndTypeParams {
    use std::vector;

    // Helper functions for creating vectors
    public fun create_u8_vector(): vector<u8> {
        let v = vector::empty<u8>();
        vector::push_back(&mut v, 10);
        vector::push_back(&mut v, 20);
        v
    }

    public fun create_u16_vector(): vector<u16> {
        let v = vector::empty<u16>();
        vector::push_back(&mut v, 100);
        vector::push_back(&mut v, 200);
        v
    }

    // Function to test variable shadowing, type parameters, and references
    public fun test_shadowing_and_types<T1, T2>() {
        // Variable shadowing with destructuring assignment
        let (a, b) = (1u8, 2u8);
        {
            // Shadow a and b inside nested block
            let (a, b) = (11u8, 22u8);
            // Assert that inner a and b are shadowed correctly
            assert!(a == 11u8, 0);
            assert!(b == 22u8, 0);
        };
        // After inner block, a and b should have original values
        assert!(a == 1u8, 0);
        assert!(b == 2u8, 0);

        // Use type parameters with referencing
        // Instantiate vector for T1
        let vec_t1: vector<T1> = {
            // Create vector T1
            let v = vector::empty<T1>();
            // Push a default value if T1 is u8 or u16
            // As Move doesn't support runtime type checks,
            // assume test is called with concrete types that are assignable
            // For simplicity, leave v empty
            v
        };

        // Instantiate vector for T2
        let vec_t2: vector<T2> = vector::empty<T2>();

        // References:
        // Create a vector for u8 for testing borrow
        let v: vector<u8> = create_u8_vector();

        // To avoid conflicting borrows, create a scope
        {
            // Borrow immutable reference
            let immut_ref: &u8 = vector::borrow(&v, 0);
            // Borrow mutable reference (Note: cannot borrow mutable while immutable borrow exists)
            // So, we need to split the borrow to two separate scopes
            // But since we want to follow the same logic, create mutable borrow in nested scope

            // Create mutable borrow in nested scope
            let v_mut = v; // Move v into v_mut to get exclusive mut borrow
            let mut_ref: &mut u8 = vector::borrow_mut(&mut v_mut, 1);
            // Read from immut_ref
            let _val_a = *immut_ref;
            // Modify through mutable reference
            *mut_ref = 99;
            // After modification, optional: do assertions if needed
        }
        // After the inner scope, the mutable borrow ends, and v is no longer borrowed mutably
        // Check the value after mutation
        // To verify, create a fresh vector or keep v mutable and perform borrow again
        // For simplicity, recreate vector and check value
        let v2: vector<u8> = create_u8_vector();
        assert!(*vector::borrow(&v2, 1) == 99, 0);
    }

    // Runner function to test everything
    public fun run_tests() {
        // Invoke for concrete types for illustration
        test_shadowing_and_types<u8, u16>();
    }
}


//# run 0xDEAD::ShadowingAndTypeParams::run_tests
