//# publish
module 0x1::TestModule {
    use std::debug;
    use std::option;

    // Top-level spec block: define a function to demonstrate features
    public fun run_experiment() {
        // Feature 1: Log detailed debug info
        debug::print("Starting experiment with detailed debug info.");

        // Feature 3: Declare a literal address with byte sequence
        let literal_address_bytes = b"0x1234";
        debug::print(&format!("Literal address bytes: {:?}",
                              std::vector::borrow(&literal_address_bytes)));

        // Simulate including debug information about bytecode dump name
        // (In actual compiler tests, this would generate debug info bytes)
        debug::print("Bytecode dump name: source_file.move");

        // Feature 4: Multiple entries for same experiment
        // First experiment attempt
        debug::print("Experiment entry 1");
        // Override with later experiment entry
        debug::print("Experiment entry 2 (overrides previous)");

        // Additional feature: define a spec with multiple nested features
        debug::print("Nested feature enabled");
    }

    // Runner function to invoke the above
    public fun run() {
        run_experiment();
    }
}

//# run 0x1::TestModule::run

//# publish
module 0x2::ExperimentOverrides {
    // This module is intentionally empty, just for override testing
}

//# run 0x2::ExperimentOverrides::run
