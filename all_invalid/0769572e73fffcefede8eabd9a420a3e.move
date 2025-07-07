module 0xCAFE::NestedInlineAndEmptyVectors {
    use std::vector;

    const MODULE_MAGIC: u32 = 0xCADE;

    struct DummyStruct has copy, drop, store, key {
        id: u64,
        value: bool,
    }

    // A nested inline function that returns a calculated value
    public inline fun calculate_value(a: u16): u16 {
        a * 2
    }

    // Function that calls the nested inline function
    public fun call_calculate(x: u16): u16 {
        calculate_value(x)
    }

    // Function that returns empty vector of structs
    public fun get_empty_struct_vector(): vector<DummyStruct> {
        vector::empty<DummyStruct>()
    }

    // Function that returns an empty vector of signers
    public fun get_empty_signer_vector(): vector<signer> {
        vector::empty<signer>()
    }

    // Function that returns an empty vector of generics (here, u8)
    public fun get_empty_generic_vector<T>(): vector<T> {
        vector::empty<T>()
    }

    // Function that returns a nested vector (empty) of u8
    public fun get_nested_empty_vector(): vector<vector<u8>> {
        vector::empty<vector<u8>>()
    }

    // Function with a while loop with invariants
    public fun count_to_ten(): u8 {
        let counter = 0u8;

        while (counter < 10) {
            // spec invariant: counter is always between 0 and 10
            // The invariant in Move is expressed as a comment as there's no explicit syntax
            // in this code for invariants, but we acknowledge it here.
            counter = counter + 1;
        };
        counter
    }

    // Main function to test all above functionalities
    public fun run_tests(): u8 {
        let result1 = call_calculate(5u16); // should be 10
        let result2 = get_empty_struct_vector(); // should be empty
        let result3 = get_empty_signer_vector(); // should be empty
        let result4 = get_empty_generic_vector<u8>(); // should be empty
        let result5 = get_nested_empty_vector(); // should be empty nested vector
        let count_result = count_to_ten(); // should be 10
        // Return the result of call_calculate, which is a u16, cast to u8 for consistent return
        // but since the function expects u8, ensure result is u8
        result1 as u8
    }
}


//# run 0xCAFE::NestedInlineAndEmptyVectors::run_tests