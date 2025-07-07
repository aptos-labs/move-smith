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
        let v = vector::empty<u128>();
        vector::push_back(&mut v, s.field1 as u128);
        vector::push_back(&mut v, s.field2 as u128);
        vector::push_back(&mut v, if (s.field3) { 1 } else { 0 });
        v
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
