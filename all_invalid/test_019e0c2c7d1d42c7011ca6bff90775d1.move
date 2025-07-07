//# publish
module 0xabcde::variable_mutation {
    fun compute(): u64 {
        let a = 10;
        let b = 20;
        let c = a + b;
        let d = c - a;
        let e = d * 2;
        e
    }

    public fun main() {
        assert!(compute() == 30, 6);
    }
}

//# run 0xabcde::variable_mutation::main

//# publish
module 0xabcde::nested_expression {
    fun modify_and_compute(): u64 {
        let x = 42;
        let y = 10;
        let mut total = 0;

        total = total + {
            let tmp = x - 5;
            tmp + y
        };

        total = total + {
            let tmp = y * 3;
            tmp - 4
        };

        total
    }

    public fun main() {
        assert!(modify_and_compute() == 82, 6);
    }
}

//# run 0xabcde::nested_expression::main

//# publish
module 0xabcde::feature_flags {
    use std::vector;

    /// Struct to store feature flags as a bitset.
    struct Features has key {
        features: vector<u8>,
    }

    /// Checks if a specific feature is enabled.
    fun contains(features: &vector<u8>, feature: u64): bool {
        let byte_index = feature / 8;
        let bit_mask = 1 << (feature % 8) as u8;
        vector::length(features) > byte_index && (
            *vector::borrow(features, byte_index) & bit_mask != 0
        )
    }

    /// Sets or clears a feature flag.
    fun set(features: &mut vector<u8>, feature: u64, enable: bool) {
        let index = feature / 8;
        while (vector::length(features) <= index) {
            vector::push_back(features, 0);
        };
        let byte = vector::borrow_mut(features, index);
        let mask = 1 << (feature % 8) as u8;
        if (enable) {
            *byte = *byte | mask;
        } else {
            *byte = *byte & (!mask);
        }
    }

    /// Enables multiple features from a vector of feature indices.
    public fun enable_multiple(s: signer, enable_features: vector<u64>) acquires Features {
        move_to<Features>(&s, Features { features: vector[] });
        let features = &mut borrow_global_mut<Features>(@0xfeed).features;

        let i = 0;
        let n = vector::length(&enable_features);
        while (i < n) {
            let feature_index = *vector::borrow(&enable_features, i);
            set(features, feature_index, true);
            i = i + 1;
        };
    }

    /// Checks the feature toggle accuracy after enabling/disabling.
    public fun test(s: signer) acquires Features {
        move_to<Features>(&s, Features { features: vector[] });
        let features = &mut borrow_global_mut<Features>(@0xfeed).features;

        // Enable features 1, 4, 8
        enable_multiple(s, vector[1, 4, 8]);

        // Verify that features 1, 4, 8 are enabled
        assert!(contains(&features, 1), 0);
        assert!(contains(&features, 4), 1);
        assert!(contains(&features, 8), 2);

        // Verify toggling off feature 4
        set(features, 4, false);
        assert!(!contains(&features, 4), 3);
    }
}

//# run 0xabcde::feature_flags::test --signers 0xfeed