//# publish
module 0xTEST::ExperimentFlags {
    // A resource to hold experiment flags
    struct Flags has key {
        enabled_flags: vector<string>,
        disabled_flags: vector<string>,
    }

    // Initialize flags resource
    public fun init(account: &signer) {
        move_to(account, Flags {
            enabled_flags: vector::empty<string>(),
            disabled_flags: vector::empty<string>(),
        });
    }

    // Enable a specific experiment flag
    public fun enable_flag(account: &signer, flag: string) {
        let flags = borrow_global_mut<Flags>(signer::address_of(account));
        vector::push_back(&mut flags.enabled_flags, flag);
    }

    // Disable a specific experiment flag
    public fun disable_flag(account: &signer, flag: string) {
        let flags = borrow_global_mut<Flags>(signer::address_of(account));
        vector::push_back(&mut flags.disabled_flags, flag);
    }

    // Check if an experiment flag is enabled
    public fun is_enabled(account: &signer, flag: string): bool {
        let flags = borrow_global<Flags>(signer::address_of(account));
        let mut i = 0;
        while (i < vector::length(&flags.enabled_flags)) {
            if (vector::borrow(&flags.enabled_flags, i) == &flag) {
                return true;
            }
            i = i + 1;
        }
        false
    }
}

//# publish
module 0xTEST::FeatureTest {
    use 0xTEST::ExperimentFlags;

    // Members declarations to import specific members
    members {
        // Import the enable_flag function as enable_feature
        enable_feature as enable_experiment;
        // Import is_enabled function
        check_feature as is_experiment_enabled;
    }

    // Alias the imported functions for clarity
    public fun enable_feature(account: &signer, flag: string) {
        ExperimentFlags::enable_flag(account, flag);
    }

    public fun check_feature(account: &signer, flag: string): bool {
        ExperimentFlags::is_enabled(account, flag)
    }

    // Test function that uses sequences of expressions and experiment flags
    public fun run_tests(account: &signer) {
        // Initialize flags resource
        ExperimentFlags::init(account);

        // Enable "FeatureA"
        enable_experiment(account, "FeatureA");

        // Use a sequence to check features and perform operations
        seq {
            // Check if FeatureA is enabled
            let is_feature_a = check_feature(account, "FeatureA");
            // Disable FeatureA
            ExperimentFlags::disable_flag(account, "FeatureA");
            // Check again
            let is_feature_a_after = check_feature(account, "FeatureA");
        }
    }
}

//# run 0xTEST::FeatureTest::run_tests --signers 0xABCDE