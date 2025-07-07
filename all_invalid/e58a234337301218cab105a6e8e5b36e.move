
//# publish
module 0xDEAD::VerifierErrorTest {
    use std::vector;

    // Struct with multiple type parameters and invalid fields to trigger bytecode verifier errors
    struct MultiTypeStruct<T1, T2> has copy, drop, store {
        // Intentional invalid field, such as duplicate field or wrong type, to cause verification error
        field1: T1,
        field2: T2,
        // Invalid: duplicate field name
        field1_duplicate: T2,
    }

    // Enum with multiple parameters to test verification error for enum instantiation
    enum MultiEnum<U, V> has copy, drop {
        VariantOne,
        VariantTwo(U, V),
        // Intentional invalid variant, missing fields
        VariantInvalid,
    }

    // Function to instantiate the above struct with multiple type parameters and resolve range list
    public fun create_multi_type_struct<T1: copy + drop, T2: copy + drop>(a: T1, b: T2): MultiTypeStruct<T1, T2> {
        // Construct with duplicates to trigger verifier diagnostic
        let s = MultiTypeStruct {
            field1: a,
            field2: b,
            field1_duplicate: a,
        };
        s
    }

    // Function to create enum with multiple parameters, intended to cause verifier errors
    public fun create_multi_enum<U: copy + drop, V: copy + drop>(u: U, v: V): MultiEnum<U, V> {
        // Instantiate a valid variant
        let e1 = MultiEnum::VariantTwo(u, v);
        // Instantiate invalid variant to trigger verifier error
        // (Will not compile, but test check for verification diagnostics)
        let e2 = MultiEnum::VariantInvalid;
        e1
    }

    // Function to construct range list with location info and secondary type range list
    public fun range_list_with_location_and_secondary() {
        // Range list: (start, end, location_pointer)
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
    public fun run_verification_tests() {
        create_multi_type_struct(1u8, true);
        create_multi_enum(2u16, 3u16);
        range_list_with_location_and_secondary();
    }
}

//# run 0xDEAD::VerifierErrorTest::run_verification_tests


// Featurres:
// b9357e244c52fd0cedc9e42b9dd30082: Display the bytecode verifier's unexpected status codes and diagnostics when verification errors occur in Move modules
// da67a855c6357f72934f12020e1bde4a: Specify multiple type parameters separated by commas within the angle brackets.
// a2088fcd0015806baed7a0033e8cd932: Construct a range list with location information for each binding and range pair.
