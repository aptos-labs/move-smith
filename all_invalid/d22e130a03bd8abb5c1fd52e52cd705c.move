//# publish
module 0xDEADBEEF::TestModule {
    use 0x1::UnitTest;
    use 0x1::Signer;

    // Testing override of experiment flags
    // The function will accept a vector of key-value string pairs to set experiments
    public fun test_override_flags(exp_flags: vector<(string, string)>) {
        let len = Vector::length(&exp_flags);
        let mut i = 0;
        while (i < len) {
            let pair = *Vector::borrow(&exp_flags, i);
            let name_ref = &pair.0;
            let value_ref = &pair.1;
            // Set experiment flag based on value
            if (String::equals(value_ref, &b"on")) {
                0x1::UnitTest::set_experiment_flag_with_name(&name_ref, true);
            } else {
                0x1::UnitTest::set_experiment_flag_with_name(&name_ref, false);
            };
            i = i + 1;
        }
    }

    // Function to test Key ability: inserting and retrieving keyed values
    public fun key_value_test() {
        let key_value: u64 = 42;
        // Using 'Key' ability: shifting 'u64' to be a key
        let table = Table::new<u64, string>();
        Table::add(&table, key_value, b"test_value");
        let retrieved = Table::get(&table, key_value);
        // We could assert here, but as per instruction, ignore assertions.
        // To demonstrate, just a no-op
        let _ = retrieved;
    }

    // Function to call create_signers_for_testing
    public fun run_unit_test_poison() {
        0x1::UnitTest::create_signers_for_testing(0);
    }

    // Optional runner function, to be invoked if needed
    public fun run_all_tests() {
        // Example: override exp flags
        let flags = Vector::empty();
        // Add flags: e.g., ("feature_x", "on"), ("feature_y", "off")
        Vector::push_back(&mut flags, (b"feature_x", b"on"));
        Vector::push_back(&mut flags, (b"feature_y", b"off"));
        Self::test_override_flags(flags);
        // Run key-value test
        Self::key_value_test();
        // Run the poison function
        Self::run_unit_test_poison();
    }
}

//# publish
module 0xCAFE::TestScripts {
    use 0xDEADBEEF::TestModule;

    //# run 0xDEADBEEF::TestModule::run_all_tests
}