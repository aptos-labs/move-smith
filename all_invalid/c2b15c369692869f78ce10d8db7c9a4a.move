
//# publish
module 0xCAFE::AbilityModifiers {
    // Test for ability modifiers on structs, fields, and usage.

    struct CopyDrop has copy, drop {
        a: u8,
        b: bool,
    }

    struct StoreKey has store, key {
        addr: address,
        value: u64,
    }

    public fun create_copydrop(): CopyDrop {
        CopyDrop {a: 42, b: true}
    }

    public fun create_storekey(addr: address, val: u64): StoreKey {
        StoreKey {addr, value: val}
    }

    public fun copy_struct(s: CopyDrop): CopyDrop {
        copy s
    }

    public fun drop_struct(_s: CopyDrop) {
        // Just accept and do nothing to test drop ability
    }
}




//# run 0xCAFE::AbilityModifiers::create_copydrop




//# run 0xCAFE::AbilityModifiers::create_storekey --args 0xCAFE u64:999




//# publish
module 0xCAFE::FeatureCheck {
    use std::vector;

    // Dummy function to simulate require_move_2_and_advance call behavior
    // Since this is a test we just return true.
    public fun require_move_2_and_advance(): bool {
        true
    }

    // We'll simulate checking and declaring experiments only if present in a keyset
    struct Experiments has copy, drop, store {
        known: vector<vector<u8>>
    }

    public fun check_and_declare(experiments: &Experiments, experiment_name: vector<u8>) {
        let found = false;
        let len = vector::length(&experiments.known);
        let i = 0;
        while (i < len) {
            let e = vector::borrow(&experiments.known, i);
            if (*e == experiment_name) {
                found = true;
            };
            i = i + 1;
        };
        assert!(found, 1000);

        // Here you would declare the experiment but for test just no-op
    }

    public fun create_experiments_list(): Experiments {
        let list = vector[
            b"move_2", 
            b"big_int", 
            b"address_aliases"
        ];
        Experiments {known: list}
    }
}




//# run 0xCAFE::FeatureCheck::require_move_2_and_advance




//# run 0xCAFE::FeatureCheck::create_experiments_list




//# run 0xCAFE::FeatureCheck::check_and_declare --args 0xCAFE vector<u8>::[109,111,118,101,95,50]




//# publish
module 0xCAFE::ExperimentChecker {
    use 0xCAFE::FeatureCheck;

    public fun test_experiment() {
        let experiments = FeatureCheck::create_experiments_list();
        FeatureCheck::check_and_declare(&experiments, b"move_2");
        // We don't declare if not included, so test will abort if error
    }
}




//# run 0xCAFE::ExperimentChecker::test_experiment
