module 0x1::TestFeatures {
    use std::signer;
    use std::vector;

    /// A struct to represent an experiment setting as a (key, value) pair
    struct ExperimentSetting has copy, drop, store {
        key: vector<u8>,
        value: vector<u8>,
    }

    /// Creates an ExperimentSetting
    public fun create_setting(key: vector<u8>, value: vector<u8>): ExperimentSetting {
        ExperimentSetting { key, value }
    }

    /// Merges a list of ExperimentSetting, later entries override earlier entries by key.
    /// Returns a vector with unique keys, preserving insertion order,
    /// but overridden keys only keep the last entry.
    public fun merge_settings(settings: vector<ExperimentSetting>): vector<ExperimentSetting> {
        let mut unique_settings = vector::empty<ExperimentSetting>();
        let mut seen_keys = vector::empty<vector<u8>>();  // keys we have seen later
        
        // Iterate backwards so that later entries take precedence
        let len = vector::length(&settings);
        let mut i = len;
        while (i > 0) {
            i = i - 1;
            let setting = vector::borrow(&settings, i);

            if (!contains_key(&seen_keys, &setting.key)) {
                vector::push_back(&mut unique_settings, copy *setting);
                vector::push_back(&mut seen_keys, copy setting.key);
            }
        }

        // Re-reverse to maintain original insertion order (for first time unique entries)
        vector::reverse(&mut unique_settings);
        unique_settings
    }

    /// Helper: Check if a key exists in the vector of keys
    fun contains_key(keys: &vector<vector<u8>>, key: &vector<u8>): bool {
        let len = vector::length(keys);
        let mut i = 0;
        while (i < len) {
            let current = vector::borrow(keys, i);
            if (*current == *key) {
                return true;
            }
            i = i + 1;
        }
        false
    }

    /// Transactional test function combining all requirements
    /// Returns true if test passes, false otherwise.
    public entry fun run_test(_signer: &signer): bool {
        // 1. Function with parameters and return types: create_setting(key, value) returns ExperimentSetting done above.

        // Test that function works
        let s1 = create_setting(b"exp1", b"on");
        let s2 = create_setting(b"exp2", b"off");
        let s3 = create_setting(b"exp1", b"off"); // Will override s1 later

        // 2. Use move and copy expressions:
        // move s1 into vector, copy s2 (copy is allowed on ExperimentSetting)
        let mut settings = vector::empty<ExperimentSetting>();
        vector::push_back(&mut settings, move s1);  // move into vector
        vector::push_back(&mut settings, copy s2);  // copy
        vector::push_back(&mut settings, move s3);  // move

        // 3. Merge settings with last overrides first:
        let merged = merge_settings(settings);

        // Check merged length: s1 overridden by s3 so only 2 unique keys: exp2 and exp1
        let len = vector::length(&merged);
        if (len != 2) {
            return false;
        }

        // Validate contents by keys and values:
        let mut found_exp1 = false;
        let mut found_exp2 = false;
        let mut i = 0;
        while (i < len) {
            let setting = vector::borrow(&merged, i);
            if (*setting.key == b"exp1") {
                found_exp1 = true;
                // last value should be "off" (from s3)
                if (*setting.value != b"off") {
                    return false;
                }
            } else if (*setting.key == b"exp2") {
                found_exp2 = true;
                if (*setting.value != b"off") {
                    return false;
                }
            } else {
                return false; // unexpected key
            }
            i = i + 1;
        }
        found_exp1 && found_exp2
    }
}

// Featurres:
// 2d791d60a5f8aea86a800ebe519df3f0: Create functions with a signature that includes parameters and return types.
// 6eeb6e58084a70bf009c11c37f26ebf6: Use move and copy expressions for variable bindings.
// e3038c5f333de51fce2a3ea39680f2ac: Combine multiple experiment settings in a list, where later entries for the same experiment override earlier ones.
