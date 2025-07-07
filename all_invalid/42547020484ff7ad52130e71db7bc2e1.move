
//# publish
module 0xCAFE::QuantifiersAndBindings {
    use std::vector;

    struct DataStruct has copy, drop, store {
        a: u64,
        b: bool,
        c: vector<u8>,
    }

    public fun test_bindings(): bool {
        // Binding variables with explicit syntax in match
        let data = DataStruct { a: 42, b: true, c: b"test" };
        let result = match (data) {
            DataStruct { a: a_val, b: b_val, c: c_val } => {
                // test binding variables again
                // verify using values
                a_val == 42 && b_val == true && vector::length(&c_val) == 4
            }
        };
        result
    }

    public fun test_positional_fields(): u8 {
        // Initialize a tuple with some data
        let tuple_data = (10u8, 20u8, 30u8);

        // Use positional access to get values
        let val0 = vector::index(&[10u8, 20u8, 30u8], 0);
        let val1 = vector::index(&[10u8, 20u8, 30u8], 1);
        let val2 = vector::index(&[10u8, 20u8, 30u8], 2);

        // Return sum of fields, just for testing
        val0 + val1 + val2
    }

    public fun create_struct_with_kind(): u8 {
        // define a struct with no deprecation info (by simple declaration)
        struct S {
            x: u8,
            y: u16,
        }

        let s_instance = S { x: 255, y: 12345 };
        // Just return the 'x' field as indicator
        s_instance.x
    }

    // Function to invoke all tests
    public fun run_tests(): u8 {
        // Run bind test
        let bind_test_result = test_bindings();

        // Run positional fields test
        let positional_result = test_positional_fields();

        // Run create struct with kind
        let struct_kind_result = create_struct_with_kind();

        // Combine results just for a value
        bind_test_result as u8 + positional_result + struct_kind_result
    }
}



//# run 0xCAFE::QuantifiersAndBindings::run_tests --signers 0xBADD

// Features:
// c9b9346df30b53d250bdd273e3495a7d: Bind variables in quantifiers using explicit binding syntax.
// fb945d0ba577a3bb19b24dce900e88ac: Use positional fields represented by numeric literals (`0`, `1`, etc.) in your Move code when referring to positional data.
// afeb4b6ebb07bba12c83e2588f9fd362: Define module members with specified kinds without deprecation info
