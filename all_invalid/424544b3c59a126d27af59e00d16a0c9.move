//# publish
module 0xCAFE::TestModule {
    // Define some structs and functions to test various features

    // Struct with copy and drop abilities
    struct CopyDropStruct has copy, drop {
        value: u64,
        nested: vector<u8>,
    }

    // Struct with only store ability (no copy)
    struct StoreOnlyStruct has store {
        value: u8,
    }

    // Struct with positional fields (tuple-style struct)
    struct PositionalStruct((u128, bool, vector<u8>));

    // Function to return a CopyDropStruct
    public fun create_copy_drop_struct(val: u64, data: vector<u8>): CopyDropStruct {
        CopyDropStruct { value: val, nested: data }
    }

    // Function to return a StoreOnlyStruct
    public fun create_store_only_struct(val: u8): StoreOnlyStruct {
        StoreOnlyStruct { value: val }
    }

    // Function to create a PositionalStruct
    public fun create_positional_struct(tuple: (u128, bool, vector<u8>)): PositionalStruct {
        PositionalStruct(tuple)
    }

    // Function to verify compliance with documentation rules
    public fun verify_compliance() {
        // Create instances
        let copy_struct = create_copy_drop_struct(42, b"hello".to_vec());
        let store_struct = create_store_only_struct(255);
        let tuple_data = (123456789u128, true, b"data".to_vec());
        let positional_struct = create_positional_struct(tuple_data);

        // Variable binding with move
        let moved_copy_struct = copy_struct; // move, allowed for copy
        let moved_store_struct = store_struct;

        // Demonstrate lambda capturing with move
        let lambda_fn = move |x: u64| {
            // Inside lambda, variables captured by move
            x + moved_copy_struct.value
            // Note: nested access to fields of structs in lambdas
        };

        // Call the lambda
        let result = lambda_fn(10);

        // Use unpacking of tuple in positional struct
        // First, get the inner tuple from positional_struct
        let PositionalStruct(t) = &moved_copy_struct; // Error: mismatch? 
        // Correction: unpack the positional_struct's inner tuple
        let PositionalStruct(t) = &positional_struct;
        let (a, b, c) = *t;

        // Cast integer types
        let num_u8 = (42 as u8);
        let num_u64 = (1000 as u64);
        let num_u128 = (999999u128 as u128);

        // All above variables are used minimally to ensure compliance
        return;
    }

    // Function to test various castings and patterns
    public fun test_casts_and_destructuring() {
        let a: u8 = 5;
        let b: u64 = (a as u64);
        let c: u128 = (b as u128);

        // Create a vector literal
        let vec1 = b"abc".to_vec();
        let vec2 = b"xyz".to_vec();

        // Using tuple and destructuring
        let tuple_example = (b"X", true, vec1);
        let (letter, flag, data_vec) = tuple_example;

        // Create a positional struct with tuple
        let pos_struct = create_positional_struct((42u128, false, b"pos".to_vec()));

        // Call verify_compliance to test right usage
        verify_compliance();

        return;
    }
}

//# run 0xCAFE::TestModule::verify_compliance --signers 0xCAFE
//# run 0xCAFE::TestModule::test_casts_and_destructuring --signers 0xCAFE

// Features:
// 3b40bd96aea75ce70537ab293569a98b: Define functions that should be verified for compliance with module documentation and compiler rules.
// af4a7feb33a505a6e23a9930d1674dce: Use the 'move' or 'copy' modifiers when capturing values in lambda expressions.
// 4abf595f2f691afdfae6c6864cf9db49: Define struct variants with positional fields using parentheses (( ... ))
