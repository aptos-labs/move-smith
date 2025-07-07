//# publish
module 0x42::TestFeaturesInteraction {
    use std::vector;

    /// The enabled features, represented by a bitset stored on chain.
    struct Features has key {
        features: vector<u8>,
    }

    /// Helper to check whether a feature flag is enabled.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
        byte_index < vector::length(features) && ((*vector::borrow(features, byte_index))) & bit_mask != 0
    }

    fun set(features: &mut vector<u8>, feature: u64, include: bool) {
        let mut n = vector::length(features); // ghost var
        let _old_features = *features; // ghost var

        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
        while (vector::length(features) <= byte_index) {
            vector::push_back(features, 0);
            n = n + 1;
        };
        let entry = vector::borrow_mut(features, byte_index);
        if (include)
            *entry = *entry | bit_mask
        else
            *entry = *entry & (0xff ^ bit_mask)
    }

    /// Enable multiple feature flags at once.
    public fun enable_feature_flags(enable: vector<u64>) acquires Features {
        let features = &mut borrow_global_mut<Features>(@0xbeef).features;
        let mut i = 0;
        let n = vector::length(&enable);
        while (i < n) {
            set(features, *vector::borrow(&enable, i), true);
            i = i + 1;
        };
    }

    /// Disable multiple feature flags at once.
    public fun disable_feature_flags(disable: vector<u64>) acquires Features {
        let features = &mut borrow_global_mut<Features>(@0xbeef).features;
        let mut i = 0;
        let n = vector::length(&disable);
        while (i < n) {
            set(features, *vector::borrow(&disable, i), false);
            i = i + 1;
        };
    }

    /// Run a test to verify that enabling/disabling features updates the bitset correctly.
    public fun test(s: signer) acquires Features {
        move_to<Features>(&s, Features { features: vector[0, 0, 0, 0] });
        // Enable feature 1 and 10
        enable_feature_flags(vector[1, 10]);
        // Disable feature 1
        disable_feature_flags(vector[1]);
        // Enable feature 20 and 23
        enable_feature_flags(vector[20, 23]);
        // Disable feature 10 and 23
        disable_feature_flags(vector[10, 23]);

        let features = &borrow_global<Features>(@0xbeef).features;

        // Feature 1: disabled
        assert!(!contains(features, 1), 0);
        // Feature 10: disabled
        assert!(!contains(features, 10), 1);
        // Feature 20: enabled
        assert!(contains(features, 20), 2);
        // Feature 23: disabled
        assert!(!contains(features, 23), 3);
        // Feature 0: should remain disabled
        assert!(!contains(features, 0), 4);
    }
}

//# run 0x42::TestFeaturesInteraction::test --signers 0xbeef