//# publish
module 0xBADD::SpecOnlyModule {
    use std::vector;

    struct DummyStruct has copy, drop, store {
        dummy_field: u64
    }

    // Change the function to be a private helper if used only internally
    fun verify_dummy_struct(d: &DummyStruct): bool {
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
    use 0xBADD::SpecOnlyModule;

    public fun run_verification(s: signer) {
        // Create a dummy struct for verification
        let dummy = SpecOnlyModule::DummyStruct { dummy_field: 123u64 };
        // Call the verification function
        let result = verify_dummy_struct(&dummy);
        // You might want to assert or check 'result' if needed
    }

    public fun test_while_loop(): u64 {
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
