//# publish
module 0xCAFE::PrivilegedOps {
    struct PrivStruct has store, key {
        secret: u64,
    }

    public fun create_priv_struct(secret: u64): PrivStruct {
        PrivStruct { secret }
    }

    // This function allows reading secret but only within this module
    public fun read_secret(s: &PrivStruct): u64 {
        s.secret
    }

    // Attempt to update secret - only allowed here
    public fun update_secret(s: &mut PrivStruct, new_secret: u64) {
        s.secret = new_secret;
    }
}

//# publish
module 0xCAFE::PrivilegedUser {
    use std::signer;
    use 0xCAFE::PrivilegedOps;

    // Attempt to create the struct through module PrivilegedOps - allowed 
    // since public function returns struct, but fields are inaccessible here.

    // Returns the struct to caller, not allowing direct field access here
    public fun call_create(secret: u64): PrivilegedOps::PrivStruct {
        PrivilegedOps::create_priv_struct(secret)
    }

    // Attempt to read secret field directly - compile error if uncommented
    // public fun illegal_field_access(s: &PrivilegedOps::PrivStruct): u64 {
    //     s.secret
    // }

    // Instead can call privileged module's read_secret function
    public fun read_secret_from_priv_struct(s: &PrivilegedOps::PrivStruct): u64 {
        PrivilegedOps::read_secret(s)
    }

    // Try to update secret via passing mutable reference, allowed only within PrivilegedOps
    // Compiler will forbid field access here, so no direct update here.

    // We provide a wrapper that calls privileged update function using a friend or via callback simulated
    public fun try_update_secret(s: &mut PrivilegedOps::PrivStruct, new_secret: u64) {
        // No direct access, so no update here
        // Just a placeholder to show no direct mutation allowed here.
        ()
    }
}

//# publish
module 0xCAFE::OptionalConstraint {
    // Function: only works if T supports drop ability
    public fun constrained_function<T: drop>(x: T): u64 {
        42u64 + 1
    }

    // Function without constraints
    public fun unconstrained_function<T>(x: T): u64 {
        7u64
    }

    // Function with more than one constraint
    public fun multi_constraint<T: copy + drop>(x: T): u64 {
        99u64
    }
}

//# publish
module 0xCAFE::ColorDiagnostic {
    use std::debug;

    // Simulate environment variable check:
    // If env var "DIAG_COLOR" == b"NONE", disable color diagnostics;
    // else, enable color diagnostics (dummy logic).

    // We simulate this with a param to indicate environment setting,
    // because Move has no real env vars access.

    public fun print_diagnostic(color_setting: vector<u8>, msg: vector<u8>) {
        if (vector::length(&color_setting) == 4 &&
            *vector::borrow(&color_setting, 0) == b'N'[0] &&
            *vector::borrow(&color_setting, 1) == b'O'[0] &&
            *vector::borrow(&color_setting, 2) == b'N'[0] &&
            *vector::borrow(&color_setting, 3) == b'E'[0]) {
            // Print without color (simulate)
            debug::print(&msg);
        } else {
            // Print with color (simulate)
            debug::print(&vector::concat(&b"[COLOR] "[0], &msg));
        };
    }
}

//# run 0xCAFE::PrivilegedUser::call_create --args 123456789u64

//# run 0xCAFE::PrivilegedUser::read_secret_from_priv_struct --args (0xCAFE::PrivilegedOps::create_priv_struct(987654321u64))

//# run 0xCAFE::OptionalConstraint::constrained_function --args 10u64

//# run 0xCAFE::OptionalConstraint::unconstrained_function --args 10u64

//# run 0xCAFE::OptionalConstraint::multi_constraint --args 10u64

//# run 0xCAFE::ColorDiagnostic::print_diagnostic --args b"NONE" b"Diagnostics without color"

//# run 0xCAFE::ColorDiagnostic::print_diagnostic --args b"COLOR" b"Diagnostics with color"


// Featurres:
// da167b1970ccb5deda57add2fd12ed02: Ensure privileged operations on structs cannot be performed across module boundaries.
// ec762062220ebd6de7077c8bb9042449: Create functions with optional type constraints that are parsed when present.
// 064d9fdd5f44111051f10668210602d5: Display diagnostics with color-only if environment variable is set to 'NONE'.
