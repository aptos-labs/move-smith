// Address declaration outside modules/scripts
const TEST_ADDRESS: address = 0xC0FF;


//# publish
module 0xC0FF::TestFeatures {
    use std::signer;

    // Run inside the module: public functions to test aborts
    public fun abort_in_if() {
        if (true) {
            abort 999;
        }; // expecting abort 999
        // no return
    }

    public fun abort_in_else() {
        if (false) {
            // do nothing
        } else {
            abort 888;
        }; // expecting abort 888
    }

    public fun abort_in_block() {
        {
            abort 777;
        }; // expecting abort 777
        // no return
    }

    // Optional runner to invoke abort functions, not mandatory for the test
    public fun run_abort_tests() {
        // intentionally empty, just to be called
    }
}


//# run 0xC0FF::TestFeatures::abort_in_if --signers 0xC0FF
//

//# run 0xC0FF::TestFeatures::abort_in_else --signers 0xC0FF
//

//# run 0xC0FF::TestFeatures::abort_in_block --signers 0xC0FF


// Featurres:
// 0f2ba8de28757add17a6d79a7e032fb6: Declare an address block outside of modules or scripts.
// b705033fbf3cb73d4bd53229d6f09878: Create let bindings with variable names, post-state information, and defining expressions.
// edc9d0d61de6fbc8b2234f66db223e99: Test that abort statements inside both conditional branches and code blocks correctly cause execution to abort with the expected error code.
