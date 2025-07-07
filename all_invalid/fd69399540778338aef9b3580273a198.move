// The following transactional test exercises:
// 1) Module/script/address filtering by publishing multiple modules/scripts at different addresses.
// 2) Custom error reporting using bytecode_verifier_mismatch_bug function (simulated).
// 3) Accessing a constant via an inline public function across modules.

//# publish
module 0xCAFE::VerifierBugTest {
    use std::error;
    use std::vector;

    // We simulate a custom error reporting with a helper function that can represent
    // a bytecode_verifier_mismatch_bug scenario by aborting with an error code and message.

    /// This constant simulates an error code
    const ERROR_CODE: u64 = 0xBEEFBEEF;

    /// Some dummy constant to expose via inline function
    const MAGIC_NUMBER: u64 = 123456789;

    /// Public inline function that returns a constant
    public inline fun get_magic_number(): u64 {
        MAGIC_NUMBER
    }

    /// Simulate a verifier mismatch bug handler
    public fun bytecode_verifier_mismatch_bug(msg: vector<u8>): ! {
        // Abort with ERROR_CODE: Aborts the transaction with the code and message.
        abort_with_message(ERROR_CODE, msg);
    }

    /// Helper function that aborts a transaction with the provided code and message
    public fun abort_with_message(code: u64, msg: vector<u8>): ! {
        // In real aptos std lib, you would emit the error with a code and message, here we just abort
        // since custom error reporting is limited in Move for tests.
        abort code;
    }

    /// Runner function tests the verifier bug reporting by forcibly aborting with a message.
    public fun test_verifier_bug(): u64 {
        // We simulate detection of a bug and call the abort helper.
        let msg = b"Verifier mismatch bug triggered\n";
        bytecode_verifier_mismatch_bug(msg);
        // This line is unreachable but required syntactically.
        0
    }
}
//# run 0xCAFE::VerifierBugTest::test_verifier_bug --signers 0xCAFE


//# publish
module 0xCAFE::ConstantsProvider {
    /// A constant defined here to be accessed via an inline function
    const SECRET_CONST: u64 = 0xDEADBEEFDEADBEEFu64;

    /// Inline function to expose SECRET_CONST
    public inline fun get_secret(): u64 {
        SECRET_CONST
    }
}


//# publish
module 0xCAFE::ConstantsUser {
    /// Imports the ConstantsProvider to access its constant via inline function call.
    use 0xCAFE::ConstantsProvider;

    /// Inline function wraps the call to ConstantsProvider's get_secret
    public inline fun retrieve_secret(): u64 {
        ConstantsProvider::get_secret()
    }

    /// Runner that calls retrieve_secret() and returns the value
    public fun runner(): u64 {
        let secret = retrieve_secret();
        secret
    }
}
//# run 0xCAFE::ConstantsUser::runner --signers 0xCAFE


//# run
script {
    use 0xCAFE::VerifierBugTest;
    use 0xCAFE::ConstantsUser;

    fun main() {
        // Test accessing constant via inline function across modules
        let secret_value = ConstantsUser::runner();
        // We do nothing with secret_value (No assertions needed per instructions)

        // We also test the verifier bug function via module call
        // We do NOT call VerifierBugTest::test_verifier_bug here in script because it aborts forcibly.

        // Demonstrate filtering capability by running only this script and above commands
        // (simulated by publishing modules at 0xCAFE and running functions)
    }
}

// Featurres:
// aea0924f9167959f01edde6ae806553e: Filter modules, scripts, or addresses based on specific criteria during compilation.
// 07021c9da5604a5c564d6847f0e94548: Handle verification errors gracefully with custom error reporting through bytecode_verifier_mismatch_bug.
// 3057bcc47366c67b20f424c510e5dd1c: Test that a constant defined in one module can be accessed via an inlined public function and then invoked from another module.
