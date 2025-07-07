//# publish
module 0xA11C::FeatureInteractionTest {
    use std::vector;

    /// The feature flags, stored as a bitset on chain.
    struct Features has key {
        features: vector<u8>,
    }

    /// Checks if a feature is contained in the bitset.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1u8 << (feature % 8) as u8;
        if (byte_index < vector::length(features)) {
            (*vector::borrow(features, byte_index)) & bit_mask != 0
        } else {
            false
        }
    }

    /// Sets or unsets a feature flag.
    fun set(features: &mut vector<u8>, feature: u64, enable: bool) {
        let byte_index = feature / 8;
        let bit_mask = 1u8 << (feature % 8) as u8;

        // Expand vector if necessary
        while (vector::length(features) <= byte_index) {
            vector::push_back(features, 0);
        }

        let entry = vector::borrow_mut(features, byte_index);
        if (enable) {
            *entry = *entry | bit_mask;
        } else {
            *entry = *entry & (0xff ^ bit_mask);
        }
    }

    /// Enables multiple features at once.
    public fun enable_multi_features(enable: vector<u64>) acquires Features {
        let features = &mut borrow_global_mut<Features>(@0xcafe).features;
        let i = 0;
        let n = vector::length(&enable);
        while (i < n) {
            let feat = *vector::borrow(&enable, i);
            set(features, feat, true);
            i = i + 1;
        }
    }

    /// Disables multiple features at once.
    public fun disable_multi_features(disable: vector<u64>) acquires Features {
        let features = &mut borrow_global_mut<Features>(@0xcafe).features;
        let i = 0;
        let n = vector::length(&disable);
        while (i < n) {
            let feat = *vector::borrow(&disable, i);
            set(features, feat, false);
            i = i + 1;
        }
    }

    /// Function to test toggling features and interactions.
    public fun test(s: signer) acquires Features {
        // Initialize features with some defaults
        move_to<Features>(&s, Features { features: vector[7, 0] }); // bits: feature 0 (LSB of first byte) and feature 15 (MSB of second byte)

        // Enable features 1, 8, 15
        enable_multi_features(vector[1, 8, 15]);
        // Disable feature 0
        disable_multi_features(vector[0]);

        // Assert - feature 1 should be enabled
        assert!(contains(&borrow_global<Features>(@0xcafe).features, 1), 0);
        // Feature 8 should be enabled
        assert!(contains(&borrow_global<Features>(@0xcafe).features, 8), 1);
        // Feature 15 should be enabled
        assert!(contains(&borrow_global<Features>(@0xcafe).features, 15), 2);
        // Feature 0 should be disabled
        assert!(!contains(&borrow_global<Features>(@0xcafe).features, 0), 3);
        // Feature 7 should remain disabled
        assert!(!contains(&borrow_global<Features>(@0xcafe).features, 7), 4);
        // Feature 16 should be disabled (not set)
        assert!(!contains(&borrow_global<Features>(@0xcafe).features, 16), 5);
    }
}

//# run 0xA11C::FeatureInteractionTest::test --signers 0xa11c