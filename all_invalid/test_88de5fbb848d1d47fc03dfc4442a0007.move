//# publish
module 0xAABB::FeatureInteraction {
    use std::vector;

    /// Stores feature flags as a bitset.
    struct Features has key {
        features: vector<u8>,
    }

    /// Checks if a specific feature is enabled.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
        byte_index < vector::length(features) && ((*vector::borrow(features, byte_index))) & bit_mask != 0
    }

    /// Enables specific features based on a list of feature indices.
    fun enable_feature_flags(enable: vector<u64>, features: &mut vector<u8>) {
        let n = vector::length(&enable);
        let i = 0;
        while (i < n) {
            let feat = *vector::borrow(&enable, i);
            let byte_index = feat / 8;
            let bit_mask = 1 << ((feat % 8) as u8);
            while (vector::length(features) <= byte_index) {
                vector::push_back(features, 0);
            }
            let entry = vector::borrow_mut(features, byte_index);
            *entry = *entry | bit_mask;
            i = i + 1;
        }
    }

    /// Test function to validate enabling features and checking their status.
    public fun test(signer: signer) acquires Features {
        // Initialize Features resource for the signer
        move_to<Features>(&signer, Features { features: vector[] });
        let features_ref = &mut borrow_global_mut<Features>(@0xAABB);
        let features = &mut features_ref.features;

        // Define features to enable
        let enable_list = vector[0u64, 7u64, 15u64];

        // Enable features
        enable_feature_flags(enable_list, features);

        // Checks
        assert!(contains(features, 0), 0);    // Feature 0 should be enabled
        assert!(contains(features, 7), 1);    // Feature 7 should be enabled
        assert!(contains(features, 15), 2);   // Feature 15 should be enabled
        assert!(!contains(features, 1), 3);   // Feature 1 should not be enabled
        assert!(!contains(features, 14), 4);  // Feature 14 should not be enabled
        assert!(!contains(features, 16), 5);  // Feature 16 should not be enabled
    }

    /// Sequential arithmetic test to perform multiple calculations on a local variable.
    fun arithmetic_sequence(): u64 {
        let acc = 10;
        // Add
        let temp1 = acc + 20;     // 30
        // Subtract
        let temp2 = temp1 - 5;    // 25
        // Multiply
        let temp3 = temp2 * 2;    // 50
        // Integer division
        let temp4 = temp3 / 5;    // 10
        // Modulo
        let temp5 = temp4 % 4;    // 2
        // Add again
        let result = temp5 + 3;   // 5
        result
    }

}

//# run 0xAABB::FeatureInteraction::test --signers 0xaabb
//# run 0xAABB::FeatureInteraction::arithmetic_sequence