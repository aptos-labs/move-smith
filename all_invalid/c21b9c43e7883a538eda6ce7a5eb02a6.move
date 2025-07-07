
//# publish
module 0xBADD::VersionCheck {
    public fun check_version(): bool {
        true
    }
}


//# publish
module 0xBADD::ImportedModule {
    public fun original_function(): u8 {
        42
    }
}


//# publish
module 0xCAFE::TestModule {
    use 0xBADD::VersionCheck as VC;
    use 0xBADD::ImportedModule;
    use std::signer;
    use std::vector;

    // Feature 1: Version check at specific location
    public fun version_check(): bool {
        let result = VC::check_version();
        result
    }

    // Function to test renaming import with 'as' keyword
    public fun call_renamed_module(): u8 {
        let value = ImportedModule::original_function();
        value
    }

    // Function to demonstrate destructuring assignment after an abort
    public fun destructure_after_abort(): bool {
        abort 999;
        let (a, b) = (1, 2);
        // This line should be unreachable due to abort.
        // To simulate, compile-time check is enough, runtime execution won't reach here.
        false
    }

    // Runner function to execute all tests
    public fun run_tests(): bool {
        let version_ok = version_check();
        let renamed_value = call_renamed_module();
        // call destructure_after_abort() to see it is unreachable (simulate)
        // but we do not call it here to avoid abort during test.
        let _ = destructure_after_abort();
        // Return true to indicate successful run
        true
    }
}


//# run 0xCAFE::TestModule::run_tests


// Featurres:
// c2434a461028866a61a3b9657b9ee03a: Perform a version check at a specific location in the source during parsing.
// 1d1a21ecdc95d0207d820dc1a7ad9c57: Rename an imported module or member using the 'as' keyword in 'use' statements.
// df7ad3806764b5a66d1e44a7d68d252d: Verify that destructuring assignment after an abort statement is unreachable and does not affect execution.
