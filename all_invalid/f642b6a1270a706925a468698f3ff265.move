// Use address 0xCAFE as test address

//# publish
address 0xCAFE {
module LintAndDiagTests {

    use std::diagnostics;
    use std::error;
    use std::signer;

    #[skip(unused_var, unreachable_code)]
    public fun skip_some_lints(): u64 {
        // Intentionally leaving unused var to skip unused_var lint
        let unused_var = 10u64;
        // Intentionally unreachable code after return
        if (true) {
            return 42u64;
        }
        // This is unreachable code which is skipped by the attribute
        0u64
    }

    // Function to produce a diagnostic with a primary label
    public fun emit_primary_label_diag() {
        let diag = diagnostics::create_diagnostic(
            diagnostics::Severity::Error,
            "This is the main error message with a primary label"
        );
        diagnostics::add_primary_label(&diag, 0, 5, "primary label highlights this part");
        // Emit the diagnostic
        diagnostics::publish(&diag);
    }

    // Function that enforces access control by calling access_error
    public fun enforce_access_control(caller: &signer) {
        let caller_addr = signer::address_of(caller);
        // Only allow calls from this module's addr
        if (caller_addr != @0xCAFE) {
            error::abort_code(error::access_error(0, signer::address_of(caller), @0xCAFE, b"enforce_access_control called from wrong address"));
        }
    }

    // Runner function to call all above functions without args
    public fun runner(caller: &signer) {
        let _ = skip_some_lints();
        emit_primary_label_diag();
        enforce_access_control(caller);
    }
}
}

//# run 0xCAFE::LintAndDiagTests::runner --signers 0xCAFE

//# run
script {
    use std::error;
    use 0xCAFE::LintAndDiagTests;
    use std::signer;

    fun main(acct: signer) {
        // Run skip_some_lints: lints skipped
        let value = LintAndDiagTests::skip_some_lints();
        // Run diagnostics emit with primary label
        LintAndDiagTests::emit_primary_label_diag();
        // Check access control from correct address (this script signer is 0xCAFE)
        LintAndDiagTests::enforce_access_control(&acct);
    }
}

// Featurres:
// 934f25f8d7e4c1f5e940ba86173abd13: Use the `#[skip(...)]` attribute with a list of lint check names to skip certain lint checks.
// 9692112355a6f45010dd5aa7e761e566: Render diagnostic messages with a primary label highlighting the main issue.
// 5a9eeb2526a25b17285009271b7ae4d8: Invoke `access_error` to enforce that certain operations are only performed within the defining module of the code, providing location and context information in the error message.
