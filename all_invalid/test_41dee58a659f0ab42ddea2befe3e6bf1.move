//# publish
module 0x42::TestFeaturesInteraction {
    use std::vector;

    /// The enabled features, stored as a bitset.
    struct Features has key {
        features: vector<u8>,
    }

    /// Checks whether a specific feature flag is enabled.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
        byte_index < vector::length(features) && ((*vector::borrow(features, byte_index))) & bit_mask != 0
    }

    /// Updates the feature flags by enabling or disabling a specific feature.
    fun set(features: &mut vector<u8>, feature: u64, include: bool) {
        let old_n = vector::length(features); // for tracking size
        let _old_features = *features; // ghost var
        let n = old_n; // ghost var

        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
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

    /// Enables multiple features at once.
    public fun batch_enable(features_to_enable: vector<u64>) acquires Features {
        let features_ref = &mut borrow_global_mut<Features>(@0xbeef).features;
        let mut i = 0;
        let n = vector::length(&features_to_enable);
        while (i < n) {
            set(features_ref, *vector::borrow(&features_to_enable, i), true);
            i = i + 1;
        }
    }

    /// Disables multiple features at once.
    public fun batch_disable(features_to_disable: vector<u64>) acquires Features {
        let features_ref = &mut borrow_global_mut<Features>(@0xbeef).features;
        let mut i = 0;
        let n = vector::length(&features_to_disable);
        while (i < n) {
            set(features_ref, *vector::borrow(&features_to_disable, i), false);
            i = i + 1;
        }
    }

    /// Toggles (enables if disabled, disables if enabled) features in a vector.
    public fun toggle_features(features_to_toggle: vector<u64>) acquires Features {
        let features_ref = &mut borrow_global_mut<Features>(@0xbeef).features;
        let mut i = 0;
        let n = vector::length(&features_to_toggle);
        while (i < n) {
            let feature = *vector::borrow(&features_to_toggle, i);
            // Check current state
            let current_state = contains(features_ref, feature);
            // Toggle
            set(features_ref, feature, !current_state);
            i = i + 1;
        }
    }

    /// Test function to validate enabling, disabling, and toggling features.
    public fun test(s: signer) acquires Features {
        move_to<Features>(&s, Features { features: vector[] });
        // Batch enable features 1, 8, 15
        batch_enable(vector[1, 8, 15]);
        // Assert they are enabled
        assert!(contains(&borrow_global<Features>(@0xbeef).features, 1), 0);
        assert!(contains(&borrow_global<Features>(@0xbeef).features, 8), 1);
        assert!(contains(&borrow_global<Features>(@0xbeef).features, 15), 2);
        // Features 2 and 9 should not be enabled
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 2), 3);
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 9), 4);

        // Batch disable feature 8
        batch_disable(vector[8]);
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 8), 5);
        // Toggle feature 1 and 15
        toggle_features(vector[1, 15]);
        // After toggle: 1 and 15 should be disabled
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 1), 6);
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 15), 7);
        // Feature 2 should still be disabled
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 2), 8);
        // Enable feature 2
        set(&mut borrow_global_mut<Features>(@0xbeef).features, 2, true);
        assert!(contains(&borrow_global<Features>(@0xbeef).features, 2), 9);
        // Toggle feature 2, should disable now
        toggle_features(vector[2]);
        assert!(!contains(&borrow_global<Features>(@0xbeef).features, 2), 10);
    }
}

//# run 0x42::TestFeaturesInteraction::test --signers 0xbeef