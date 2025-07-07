
//# publish
module 0xBADD::SpecOnlyModule {
    use std::vector;

    struct DummyStruct has copy, drop, store {
        dummy_field: u64
    }

    public fun verify_dummy_struct(d: DummyStruct): bool {
        d.dummy_field == 123u64
    }
}


//# publish
module 0xBADD::VerificationModule {
    // This module contains only verification specs, no executable functions
    use std::vector;
    use 0xBADD::SpecOnlyModule;

    // Specify a simple spec to verify dummy_struct
    spec verify_struct {
        funcs: [verify_dummy_struct]
    }
}


//# publish
module 0xBADD::MainModule {
    use std::signer;
    use std::vector;
    use 0xBADD::VerificationModule;

    public fun run_verification(s: signer) {
        // Create a dummy struct for verification
        let dummy = SpecOnlyModule::DummyStruct {dummy_field: 123u64};
        // Call the verification function
        verify_dummy_struct(dummy);
    }

    public fun test_while_loop() {
        let x: u64 = 0;
        let limit: u64 = 10;

        // Loop while x < limit
        while (x < limit) {
            x = x + 1;
        };
        // Final value of x should be 10
        x
    }
}


//# run 0xBADD::MainModule::run_verification --signers 0xCAFEEFACEEFACEE

//# run 0xBADD::MainModule::test_while_loop


// Featurres:
// 83ae541e328416c20a4466daa88b7654: Automatically include functions that are transitively called by public (non-inline) target functions in bytecode generation
// f398bceb356c681d2fb7b53580c66fcb: Define spec-only modules for Move smart contract verification
// e48927907b787fdbe897e6bb130f8a57: Verify that a while loop correctly updates a variable and exits when its condition becomes false.
