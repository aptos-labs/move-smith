
//# publish
module 0xCAFE::TestFeatures {
    use std::vector;
    use std::signer;

    // 1. Function to test sequence usage in binary operations with trivial sequences
    public fun test_sequences_in_binops(): u32 {
        // Use sequences with single expressions only
        let a = 1u32;
        let b = 2u32;
        let c = 3u32;

        // Binary operations with sequences of single expressions
        let sum = a + b;
        let product = b * c;
        let combined = sum + product;

        combined
    }

    // 2. Function to test adding/removing constants through filtering logic
    public fun filter_constants(input_number: u8): vector<u8> {
        let result: vector<u8> = vector::empty();

        // Filter constants based on input
        if (input_number > 10u8) {
            result = vector::push_back(&mut result, 0xAA);
        } else {
            result = vector::push_back(&mut result, 0x55);
        }

        // Remove constant 0xAA if input is even
        let filtered_result: vector<u8> = vector::filter(&result, |byte| {
            // Remove 0xAA if input_number is even
            if (byte == 0xAA && input_number % 2 == 0) {
                false
            } else {
                true
            }
        });
        filtered_result
    }

    // 3. Friend function (not inline, native, or entry) declaration
    //    Since Move does not have native "friend" semantics, simulate by non-entry non-inline, non-native functions
    //    and expose via module interface
    
    // Function to be tested as friend function
    public fun friend_function(x: u64): u64 {
        x + 42
    }
}

// test]
fun test_feature_sequences_in_binops(): u32 {
    0xCAFE::TestFeatures::test_sequences_in_binops()
}

// test]
fun test_feature_filter_constants(): vector<u8> {
    // Test with input > 10
    0xCAFE::TestFeatures::filter_constants(15u8)
}

// test]
fun test_feature_filter_constants_even_input(): vector<u8> {
    // Test with input even
    0xCAFE::TestFeatures::filter_constants(4u8)
}


//# run 0xCAFE::TestFeatures::test_sequences_in_binops

//# run 0xCAFE::TestFeatures::filter_constants --args 15u8

//# run 0xCAFE::TestFeatures::filter_constants --args 4u8

// Featurres:
// 60950f7a10df64626cbcbfcece55e39c: Use sequences within binary operations only when they are trivial, meaning they consist of a single expression or are potentially side-effect-free.
// e5f5fd47a3968d51b218de0613ea02db: Add or remove constants in scripts through filtering logic.
// ffbc920f95cc26fe8c700e5887d68631: Declare friend functions that are not inline, native, or entry functions.
