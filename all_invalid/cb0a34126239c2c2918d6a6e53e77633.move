
//# publish
module 0xCAFE::VectorLambdaTest {
    use std::vector;
    use std::vector::{push_back};
    use std::option::{Option, none, some};

    // Struct definition for testing
    struct MyStruct has copy, drop {
        key: u64,
        value: u8,
    }

    // Function to create a vector of structs
    public fun create_structs(): vector<MyStruct> {
        let vec = vector::empty<MyStruct>();
        vector::push_back(&mut vec, MyStruct { key: 1, value: 10 });
        vector::push_back(&mut vec, MyStruct { key: 2, value: 20 });
        vector::push_back(&mut vec, MyStruct { key: 3, value: 30 });
        vec
    }

    // Inline function to extract keys from structs (generic over reference)
    public inline fun extract_keys<T>(vec: &vector<T>, key_fn: &fn(&T): u64): vector<u64> {
        let result = vector::empty<u64>();
        let length = vector::length(vec);
        let i = 0;
        while (i < length) {
            let item_ref = vector::borrow(vec, i);
            let key_value = key_fn(item_ref);
            vector::push_back(&mut result, key_value);
            i = i + 1;
        }
        result
    }

    // Helper function to get key from MyStruct
    public fun get_key(s: &MyStruct): u64 {
        s.key
    }

    // Function to test iteration over vector of lambdas and storing lambda functions
    public fun generate_lambda_vector(): vector<fn(u64, u8): u64> {
        let lambdas = vector::empty<fn(u64, u8): u64>();
        // Lambda that adds key and value
        vector::push_back(&mut lambdas, |k: u64, v: u8| -> u64 { k + v as u64 });
        // Lambda that multiplies key and value
        vector::push_back(&mut lambdas, |k: u64, v: u8| -> u64 { k * v as u64 });
        lambdas
    }

    // Function to invoke lambdas with given arguments
    public fun invoke_lambdas(lambdas: &vector<fn(u64, u8): u64>, key: u64, val: u8): vector<u64> {
        let results = vector::empty<u64>();
        let length = vector::length(lambdas);
        let i = 0;
        while (i < length) {
            let lambda_ref = vector::borrow(lambdas, i);
            let res = lambda_ref(key, val);
            vector::push_back(&mut results, res);
            i = i + 1;
        }
        results
    }
}


//# run 0xCAFE::VectorLambdaTest::generate_lambda_vector --signers 0xCAFE

//# run 0xCAFE::VectorLambdaTest::invoke_lambdas --signers 0xCAFE --args 5u64 10u8


//# run 0xCAFE::VectorLambdaTest::create_structs --signers 0xCAFE

//# run 0xCAFE::VectorLambdaTest::extract_keys --signers 0xCAFE --args 0xCAFE::VectorLambdaTest::get_key

// Featurres:
// be132e2b495333820d8b02e55f4bcf08: Test that vectors can store and iterate over lambda functions, and that each lambda can be invoked with arguments during iteration.
// 7b06f0b22230fad7e263e099e9d50b24:  Parse the address string into a `NumericalAddress` object for use within the Move codebase.
// 8819767f4c31f2fc027a4533595af519: Test that mapping over a vector of struct elements by reference allows collecting their fields (keys) into a new vector using generic inline functions.
