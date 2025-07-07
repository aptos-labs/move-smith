//# publish
module 0x42::VectorsTest {
    // Struct for testing nested vectors of structs
    struct Item {
        id: u64,
        name: vector<u8>,
    }

    // Function returning an empty vector of Item structs
    public fun empty_item_vec(): vector<Item> {
        vector[]
    }

    // Function returning an empty vector of signers
    public fun empty_signer_vec(): vector<signer> {
        vector[]
    }

    // Generic function returning an empty vector of any type T
    public fun empty_generic_vec<T>(): vector<T> {
        vector[]
    }

    // Function returning nested vector of vector of Item structs
    public fun empty_item_vec_vec(): vector<vector<Item>> {
        vector[]
    }

    // Function returning nested vector of vector of signers
    public fun empty_signer_vec_vec(): vector<vector<signer>> {
        vector[]
    }

    // Generic function returning nested vector of type T
    public fun empty_generic_vec_vec<T>(): vector<vector<T>> {
        vector[]
    }
}

//# run 0x42::VectorsTest::empty_item_vec
//# run 0x42::VectorsTest::empty_item_vec
//# run 0x42::VectorsTest::empty_signer_vec
//# run 0x42::VectorsTest::empty_generic_vec --type-args 0x42::VectorsTest::Item
//# run 0x42::VectorsTest::empty_item_vec_vec
//# run 0x42::VectorsTest::empty_signer_vec_vec
//# run 0x42::VectorsTest::empty_generic_vec_vec --type-args 0x42::VectorsTest::Item

//# publish
module 0x42::InitMapAndTransform {
    use std::vector;
    const KEYS: vector<vector<u8>> = vector[vector[5u8], vector[7u8], vector[11u8]];
    const VALUES: vector<u64> = vector[10u64, 20u64, 30u64];

    // Function that adds KEY length + 2 to each key (as u64) and adds 3 to each value
    public entry fun setup() {
        // Map KEYS: for each key, compute length + 2
        let key_lengths_plus_two: vector<u64> = vector::map<vector<u8>, u64>(KEYS, |k| {
            let len: u64 = vector::length<u8>(&k);
            len + 2
        });
        // Map VALUES: add 3 to each value
        let new_values: vector<u64> = vector::map<u64, u64>(VALUES, |v| v + 3);
        // Dummy assert or state change could be here if needed
    }
}

//# run 0x42::InitMapAndTransform::setup

//# publish
module 0x42::InlineLambdaTest {
    inline fun apply_and_return(f: |u64| u64, x: u64): u64 {
        f(x)
    }

    // Function testing inline lambda application
    public fun test(): u64 {
        apply_and_return(|val| val * 2, 15)
    }

    public fun main() {
        assert!(test() == 30, 1);
    }
}

//# run 0x42::InlineLambdaTest::main