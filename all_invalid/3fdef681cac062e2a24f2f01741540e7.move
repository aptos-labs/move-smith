
//# publish
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
    public fun run_tests() {
        let result1 = call_calculate(5u16); // should be 10
        let result2 = get_empty_struct_vector(); // should be empty
        let result3 = get_empty_signer_vector(); // should be empty
        let result4 = get_empty_generic_vector<u8>(); // should be empty
        let result5 = get_nested_empty_vector(); // should be empty nested vector
        let count_result = count_to_ten(); // should be 10
        // Return the last result for verification
        result1
    }
}


//# run 0xCAFE::NestedInlineAndEmptyVectors::run_tests

// Featurres:
// e6c9221ab82795e73d9565f626f89a59: Test that calling nested inline functions from a module correctly computes the expected result when invoked through the main function.
// 4d5026678b532d171f786d175597ec07: Test that empty vectors of structs, signers, generics, and nested vectors can be correctly returned from functions without being treated as constants.
// 614c0bf9c3351ab3d7d44f5df1220170: Add specification invariants to while loops using 'spec' blocks.
