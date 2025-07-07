
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
        let vec_t1: vector<T1> = if (true) {
            // Create vector T1 with vector::push_back
            let v = vector::empty<T1>();
            // Sample push based on T1 size assumption
            // To keep it simple, just push default value if possible
            // But since no default, we push zero if T1 is u8 or u16
            // Use placeholder if needed
            // For test, assume T1 is u8 or u16
            // Will push dummy value
            // For safety, only proceed if T1 is u8 or u16
            // but Move doesn't support type checks, so assume test is for specific type args
            // We'll just ignore this check for simplicity
            v
        } else {
            vector::empty<T1>()
        };

        // Instantiate vector for T2
        let vec_t2: vector<T2> = vector::empty<T2>();

        // References:
        // Create an immutable reference and a mutable reference to an element in a vector
        let v: vector<u8> = create_u8_vector();

        // Borrow immutable reference
        let immut_ref: &u8 = vector::borrow(&v, 0);
        // Borrow mutable reference
        let mut_ref: &mut u8 = vector::borrow_mut(&mut v, 1);

        // Read from immut_ref
        let _val_a = *immut_ref;
        // Modify through mutable reference
        *mut_ref = 99;

        // After mutation, check the value
        assert!(*vector::borrow(&v, 1) == 99, 0);
    }

    // Runner function to test everything
    public fun run_tests() {
        // Invoke for concrete types for illustration
        test_shadowing_and_types<u8, u16>();
    }
}


//# run 0xDEAD::ShadowingAndTypeParams::run_tests


// Featurres:
// 5a8683e4815f33ccbf904d0d411d5c78: Test that variable shadowing with destructuring assignments in nested blocks works correctly and independently.
// 678e6ff726e24c9cffca1d8bd263c5d8: Use type parameters by referencing them with an index to support generic type definitions.
// d11c2909e02955ad40c867583b01e5bc: Test whether a mutable and an immutable reference can be simultaneously created from the same variable in a single let binding.
