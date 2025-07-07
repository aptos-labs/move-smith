//# publish
module 0xCAFE::NativeInvokeTest {
    use vector;
    use debug;
    use signer;
    use 0x1::UnitTest;

    // Public function to test invoking native function `create_signers_for_testing`.
    public fun test_create_signers(): vector<signer::Signer> {
        // Create 3 signers for testing using native function
        let signers = UnitTest::create_signers_for_testing(3u64);
        // Use debug print to display number of signers created
        debug::print(&(vector::length(&signers)));
        signers
    }

    // Runner function that creates signers and prints their addresses
    public fun run() {
        let signers = test_create_signers();
        // Iterate over each signer and print address
        let len = vector::length(&signers);
        let mut i = 0;
        while (i < len) {
            // Get signer from vector
            let signer_ref = vector::borrow(&signers, i);
            let addr = signer::address_of(signer_ref);
            debug::print(&addr);
            i = i + 1;
        };
    }
}

//# run 0xCAFE::NativeInvokeTest::run


//# publish
module 0xCAFE::UniqueModule0 {
    use debug;

    public fun hello() {
        debug::print(&1u8);
    }
}

//# run 0xCAFE::UniqueModule0::hello


//# publish
module 0xCAFE::UniqueModule1 {
    use debug;

    public fun hello() {
        debug::print(&2u8);
    }
}

//# run 0xCAFE::UniqueModule1::hello


//# publish
module 0xCAFE::DiagnosticsDisplay {
    use debug;

    public fun display_message_if_always() {
        let env_val = debug::get_env_variable(b"ALWAYS");
        if (env_val == 1u8) {
            // Print message with color code (for example: ANSI green)
            let green = b"\x1b[32m";
            let reset = b"\x1b[0m";
            debug::print(&green);
            debug::print(b"Diagnostics: ALWAYS environment variable is set");
            debug::print(&reset);
        } else {
            debug::print(b"Diagnostics: environment variable is not ALWAYS");
        };
    }
}

//# run 0xCAFE::DiagnosticsDisplay::display_message_if_always