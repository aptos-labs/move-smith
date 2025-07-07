
//# publish
module 0xDEAD::VerifierErrorTest {
    use std::vector;

    // Struct with multiple type parameters and intentionally invalid fields to trigger verifier errors
    struct MultiTypeStruct<T1: copy + drop, T2: copy + drop> has copy, drop, store {
        // Corrected: duplicate field removed or renamed if intended as invalid, but for testing, keep as invalid
        field1: T1,
        field2: T2,
        // Invalid: duplicate field name; Move does not support duplicate fields, kept here as intentional error
        // field1_duplicate: T2, // Commented out because Move doesn't allow duplicate fields
    }

    // Enum with multiple parameters to test verification error for enum instantiation
    enum MultiEnum<U: copy + drop, V: copy + drop> has copy, drop {
        VariantOne,
        VariantTwo(U, V),
        // Intentional invalid variant, missing fields, which is a compile-time error
        // VariantInvalid, // Commented out; to trigger error, uncomment the above line
    }

    // Function to instantiate the above struct with multiple type parameters and resolve range list
    pub fun create_multi_type_struct<T1: copy + drop, T2: copy + drop>(a: T1, b: T2): MultiTypeStruct<T1, T2> {
        // Construct with valid fields
        let s = MultiTypeStruct {
            field1: a,
            field2: b,
            // 'field1_duplicate' is invalid in Move; remove or comment out
        };
        s
    }

    // Function to create enum with multiple parameters, intended to cause verifier errors
    pub fun create_multi_enum<U: copy + drop, V: copy + drop>(u: U, v: V): MultiEnum<U, V> {
        // Instantiate a valid variant
        let e1 = MultiEnum::VariantTwo(u, v);
        // Instantiate invalid variant to trigger verifier error
        // (Will not compile if uncommented; kept as comment to test diagnostics)
        // let e2 = MultiEnum::VariantInvalid; // Invalid because variant is missing fields
        e1
    }

    // Function to construct range list with location info and secondary type range list
    pub fun range_list_with_location_and_secondary() {
        // Move does not support tuples directly as type arguments, so define the type accordingly
        // The tuple type is `(u64, u64, u8)` which is allowed in vector type argument
        let range_list: vector<(u64, u64, u8)> = vector::empty();
        vector::push_back(&mut range_list, (0, 10, 1));
        vector::push_back(&mut range_list, (20, 30, 2));
        vector::push_back(&mut range_list, (40, 50, 3));
        // Secondary type range list for each range (simulate with vector of booleans)
        let secondary_type_ranges: vector<bool> = vector::empty();
        vector::push_back(&mut secondary_type_ranges, true);
        vector::push_back(&mut secondary_type_ranges, false);
        vector::push_back(&mut secondary_type_ranges, true);
    }

    // Runner function to trigger the above functions intentionally causing verifier errors and range list construction
    pub fun run_verification_tests() {
        create_multi_type_struct(1u8, true);
        create_multi_enum(2u16, 3u16);
        range_list_with_location_and_secondary();
    }
}


//# run 0xDEAD::VerifierErrorTest::run_verification_tests
