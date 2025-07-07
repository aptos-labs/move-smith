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
