//# publish
module 0x123::FeatureInteractionTest {
    use std::vector;

    /// Storage for multiple feature flags.
    struct Features has key {
        features: vector<u8>,
    }

    /// Checks if a specific feature is enabled.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
        byte_index < vector::length(features) && ((*vector::borrow(features, byte_index))) & bit_mask != 0
    }

    /// Sets or clears a specific feature flag.
    fun set(features: &mut vector<u8>, feature: u64, enable: bool) {
        let old_len = vector::length(features);
        let byte_index = feature / 8;
        let bit_mask = 1 << ((feature % 8) as u8);
        // Extend vector if needed
        while (vector::length(features) <= byte_index) {
            vector::push_back(features, 0);
        }
        let entry = vector::borrow_mut(features, byte_index);
        if (enable)
            *entry = *entry | bit_mask
        else
            *entry = *entry & (0xff ^ bit_mask);
    }

    /// Enable multiple features at once.
    public fun enable_features(enable_list: vector<u64>) acquires Features {
        let features_ref = &mut borrow_global_mut<Features>(@0x1).features;
        let i = 0;
        let n = vector::length(&enable_list);
        while (i < n) {
            set(features_ref, *vector::borrow(&enable_list, i), true);
            i = i + 1;
        }
    }

    /// Disables multiple features at once.
    public fun disable_features(disable_list: vector<u64>) acquires Features {
        let features_ref = &mut borrow_global_mut<Features>(@0x1).features;
        let i = 0;
        let n = vector::length(&disable_list);
        while (i < n) {
            set(features_ref, *vector::borrow(&disable_list, i), false);
            i = i + 1;
        }
    }

    /// Checks the status of multiple features.
    public fun check_features(features: &vector<u8>, flags: vector<u64>): vector<bool> {
        let results = vector::empty<bool>();
        let i = 0;
        let n = vector::length(&flags);
        while (i < n) {
            let feature = *vector::borrow(&flags, i);
            vector::push_back(&mut results, contains(features, feature));
            i = i + 1;
        }
        results
    }

    /// Simulation of enabling, disabling, and checking feature interactions.
    public fun test_feature_interactions(s: signer) acquires Features {
        move_to<Features>(&s, Features { features: vector[0, 0] });
        let enable_list = vector[0, 2, 4]; // features to enable
        let disable_list = vector[1, 3];   // features to disable

        // Enable features 0, 2, 4
        enable_features(enable_list);
        // Disable features 1, 3
        disable_features(disable_list);

        let current_features = &borrow_global<Features>(@0x1).features;

        // Check individual features
        assert!(contains(current_features, 0), 0); // Enabled
        assert!(!contains(current_features, 1), 1); // Disabled
        assert!(contains(current_features, 2), 2);
        assert!(!contains(current_features, 3), 3);
        assert!(contains(current_features, 4), 4);

        // Check multiple features
        let check_list = vector[0, 1, 2, 3, 4];
        let results = check_features(current_features, check_list);
        // We expect: true, false, true, false, true
        assert!(*vector::borrow(&results, 0), 5);
        assert!(!*vector::borrow(&results, 1), 6);
        assert!(*vector::borrow(&results, 2), 7);
        assert!(!*vector::borrow(&results, 3), 8);
        assert!(*vector::borrow(&results, 4), 9);
    }
}

//# run 0x123::FeatureInteractionTest::test_feature_interactions --signers 0xabc