//# publish
module 0xABC::FeatureInteractionTest {
    use std::vector;

    /// The features, stored as a bitset on chain.
    struct Features has key {
        features: vector<u8>,
    }

    /// Checks if a specific feature is enabled.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1 << (feature % 8) as u8;
        byte_index < vector::length(features) && ((*vector::borrow(features, byte_index))) & bit_mask != 0
    }

    /// Sets or clears a feature flag.
    fun set(features: &mut vector<u8>, feature: u64, include: bool) {
        let old_n = vector::length(features);
        let n = old_n; // ghost var
        let byte_index = feature / 8;
        let bit_mask = 1 << (feature % 8) as u8;
        while ({
            vector::length(features) <= byte_index
        }) {
            vector::push_back(features, 0);
            n = n + 1;
        };
        let entry = vector::borrow_mut(features, byte_index);
        if (include)
            *entry = *entry | bit_mask
        else
            *entry = *entry & (0xff ^ bit_mask)
    }

    /// Enable multiple features at once.
    public fun enable_features(enable_features: vector<u64>) acquires Features {
        let features_struct = &mut borrow_global_mut<Features>(@0xDEAD);
        let features = &mut features_struct.features;
        let len = vector::length(&enable_features);
        let i = 0;
        while (i < len) {
            let feature = *vector::borrow(&enable_features, i);
            set(features, feature, true);
            i = i + 1;
        }
    }

    /// Disable multiple features at once.
    public fun disable_features(disable_features: vector<u64>) acquires Features {
        let features_struct = &mut borrow_global_mut<Features>(@0xDEAD);
        let features = &mut features_struct.features;
        let len = vector::length(&disable_features);
        let i = 0;
        while (i < len) {
            let feature = *vector::borrow(&disable_features, i);
            set(features, feature, false);
            i = i + 1;
        }
    }

    /// Test that enabling and disabling features correctly updates the bitset.
    public fun test(s: signer) acquires Features {
        move_to<Features>(&s, Features { features: vector[] });
        // Enable features 1 and 9
        enable_features(vector[1, 9]);
        // Check if features are correctly enabled
        assert!(contains(&borrow_global<Features>(@0xDEAD).features, 1), 0);
        assert!(contains(&borrow_global<Features>(@0xDEAD).features, 9), 1);
        // Features 0 and 2 should be disabled
        assert!(!contains(&borrow_global<Features>(@0xDEAD).features, 0), 2);
        assert!(!contains(&borrow_global<Features>(@0xDEAD).features, 2), 3);
        // Now disable feature 1
        disable_features(vector[1]);
        assert!(!contains(&borrow_global<Features>(@0xDEAD).features, 1), 4);
        // Enable feature 0
        enable_features(vector[0]);
        assert!(contains(&borrow_global<Features>(@0xDEAD).features, 0), 5);
        // Enable feature 2 and 10
        enable_features(vector[2, 10]);
        assert!(contains(&borrow_global<Features>(@0xDEAD).features, 2), 6);
        assert!(contains(&borrow_global<Features>(@0xDEAD).features, 10), 7);
        // Disable feature 9
        disable_features(vector[9]);
        assert!(!contains(&borrow_global<Features>(@0xDEAD).features, 9), 8);
    }
}

//# run 0xABC::FeatureInteractionTest::test --signers 0xDEAD