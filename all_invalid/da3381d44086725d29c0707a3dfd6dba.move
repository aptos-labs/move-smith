// File: tests/transactional/compile_and_run.move
// This test file is a Move script with annotations and the structure to test:
// 1. Attaching compiled modules or scripts with source maps if experimental feature enabled
// 2. Declaring parameters and checking for compiler warnings on unused parameters
// 3. Processing package definitions to include modules and address mappings

// Note: This test assumes the presence of Aptos testing infrastructure and
// experimental features enabled in the test environment for source map attachment.

// ---- Modules ----

// A simple module with an address named '0x1' to be included in the package definitions.
address 0x1 {
    module TestModule {
        // function with parameter intentionally unused to trigger compiler warning
        public fun unused_param_example(_unused_param: u64) {
            // intentionally empty body - no usage of _unused_param
        }

        // function that uses a parameter (to contrast)
        public fun used_param_example(x: u64): u64 {
            x + 1
        }
    }
}

// Another module to verify multiple modules handled in package definitions
address 0x2 {
    module AnotherModule {
        public fun dummy() {
            // no-op
        }
    }
}

// ---- Script ----

// This script declares parameters - one used and one unused to check compiler warnings.
script {
    use 0x1::TestModule;
    use 0x2::AnotherModule;

    fun main(used_param: u64, _unused_param: u64) {
        // use the 'used_param' to avoid warning
        let x = TestModule::used_param_example(used_param);
        assert!(x > 0, 1);

        // call dummy function in AnotherModule to ensure multi-module package processed
        AnotherModule::dummy();

        // call unused_param_example with _unused_param to show the warning on unused param in module
        TestModule::unused_param_example(_unused_param);
    }
}

// ---- Package Definition (for test framework internship) ----

// Normally, package definitions and address mappings are outside the Move code,
// but here we define a "pseudo" test definition snippet to show combination.

/*
Package Definition: 
- Address Mappings:
    - 0x1 => test_account_1
    - 0x2 => test_account_2

- Modules Included:
    - 0x1::TestModule
    - 0x2::AnotherModule

Experimental Features:
- source_map_attachment_enabled: true

Test Expectations:
- Compilation attaches source maps with modules/scripts.
- Compiler emits warning on unused parameters (e.g., _unused_param in unused_param_example and main).
- Processing package definitions correctly maps addresses and includes modules.
*/


// Featurres:
// 31814c30074ca60af14f830ebab8f9c5: Attach compiled modules or scripts with their source maps for further processing if the experimental feature is enabled.
// 7ecf5ea06a4c4f47d0bd671efe0b3fbb: Declare parameters in functions and have the compiler warn you if they are unused
// dbc94bb18575b7ab61689e75eac66ec5: Process package definitions to include modules and address mappings.
