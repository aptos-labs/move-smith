
//# publish
module 0xCAFE::AdvancedFeaturesTest {
    use std::vector;

    // Custom struct with mutable fields
    struct Item has store, key {
        id: u64,
        name: vector<u8>,
        value: u64,
    }

    // Function to mutate the vector items by setting their value field
    public fun mutate_items(items: &mut vector<Item>, new_value: u64) {
        let len = vector::length(items);
        let i = 0;
        while (i < len) {
            let item_ref: &mut Item = vector::borrow_mut(items, i);
            item_ref.value = new_value;
            i = i + 1;
        }
    }

    // Function to verify the mutation
    public fun verify_mutation(items: &vector<Item>, expected_value: u64): bool {
        let len = vector::length(items);
        let i = 0;
        while (i < len) {
            let item_ref: &Item = vector::borrow(items, i);
            if (item_ref.value != expected_value) {
                return false;
            };
            i = i + 1;
        };
        true
    }

    // Function to switch between native and scripted implementation
    // For demonstration, toggling a flag to represent mode
    public fun is_native_mode(flag: bool): bool {
        flag
    }

    // Function that calls different implementations based on mode
    public fun get_value_based_on_mode(mode: bool): u64 {
        if (mode) {
            // Native implementation
            42
        } else {
            // Scripted (simulated) implementation
            100
        };
    }

    // Function to simulate token stream parsing for specific token detection
    // We'll treat tokens as vector<u8> and check for a specific byte pattern
    public fun contains_token(token_stream: vector<u8>, target_token: u8): bool {
        let len = vector::length(&token_stream);
        let i = 0;
        while (i < len) {
            let token: u8 = *vector::borrow(&token_stream, i);
            if (token == target_token) {
                return true;
            };
            i = i + 1;
        };
        false
    }
}


//# run 0xCAFE::AdvancedFeaturesTest::mutate_items --signers 0xBADD --args 10u64


//# run 0xCAFE::AdvancedFeaturesTest::verify_mutation --args 10u64


//# run 0xCAFE::AdvancedFeaturesTest::get_value_based_on_mode --args true


//# run 0xCAFE::AdvancedFeaturesTest::get_value_based_on_mode --args false


//# run 0xCAFE::AdvancedFeaturesTest::contains_token --args b"abc\x01def" 1u8


//# run 0xCAFE::AdvancedFeaturesTest::contains_token --args b"xyz\x02" 1u8


// Featurres:
// 8ac46363ee65333fafab3c5023197f9e: Test that a for-each function can safely mutate elements and destructure fields by mutable reference within a generic vector, including borrowing both keys and values mutably in a custom struct.
// 3e3f947c7d1b4fc19e7bdb8b4bee8efe: Create functions with a body that can be either native or defined by a sequence of statements.
// 69e44c9bc649c147874502197d5ebd56: Check if a specific token is present in the token stream.
