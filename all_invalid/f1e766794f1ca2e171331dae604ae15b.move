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
        };
        // This is unreachable code which is skipped by the attribute
        0u64
    }

    // Function to produce a diagnostic with a primary label
    public fun emit_primary_label_diag() {
        let diag = diagnostics::create_diagnostic(
            diagnostics::Severity::Error,
            b"This is the main error message with a primary label"
        );
        diagnostics::add_primary_label(&diag, 0, 5, b"primary label highlights this part");
        // Emit the diagnostic
        diagnostics::publish(&diag);
    }

    // Function that enforces access control by calling access_error
    public fun enforce_access_control(caller: &signer) {
        let caller_addr = signer::address_of(caller);
        // Only allow calls from this module's addr
        if (caller_addr != @0xCAFE) {
            error::abort_code(error::access_error(0, caller_addr, @0xCAFE, b"enforce_access_control called from wrong address"));
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
    use 0xCAFE::LintAndDiagTests;

    fun main(acct: signer) {
        // Run skip_some_lints: lints skipped
        let value = LintAndDiagTests::skip_some_lints();
        // Run diagnostics emit with primary label
        LintAndDiagTests::emit_primary_label_diag();
        // Check access control from correct address (this script signer is 0xCAFE)
        LintAndDiagTests::enforce_access_control(&acct);
    }
}