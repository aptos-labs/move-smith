
//# publish
module 0xCAFE::TestFeatures {
    use std::debug;

    // Define a struct for testing field iteration
    struct SampleStruct has copy, drop {
        field1: u8,
        field2: u16,
        field3: bool,
    }

    // A purely functional helper to simulate field iteration by returning individual fields in a vector
    public fun get_fields(s: SampleStruct): vector<u128> {
        vector::empty<u128>()
            |> vector::push_back<u128>(s.field1 as u128)
            |> vector::push_back<u128>(s.field2 as u128)
            |> vector::push_back<u128>(if (s.field3) { 1 } else { 0 })
    }

    // Function to test that `one` correctly assigns the input to `_x` and returns `_x`
    public fun test(p: u64): u64 {
        let _x = one(p);
        _x
    }

    // Helper function that assigns its input to `_x` and returns `_x`
    public fun one(val: u64): u64 {
        let _x = val;
        _x
    }

    // Function to test iteration over struct fields
    public fun handle_fields(s: SampleStruct): vector<u128> {
        let fields = get_fields(s);
        // For demonstration, just return the vector of fields
        fields
    }
}


//# run 0xCAFE::TestFeatures::test --args 42u64


//# run 0xCAFE::TestFeatures::handle_fields --args 3u8 0 0


// Featurres:
// 82192e1c5121e4531b7cb24f03120b62: Test that the `test` function correctly assigns the input parameter `p` to the local variable `_x` after calling the `one` function and returns the value of `_x`.
// 9df22a99e19c0bc0af7a6e7e53a12d34: Attach a location to the expected failure by providing a `location` attribute within the `#[expected_failure]` attribute, either as a constant or a specific location value.
// bd28eeae1ce71d93da1b64be274d9e2f: Iterate over fields of a struct to handle each field individually.
